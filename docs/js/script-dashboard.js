// DASHBOARD GERAL

function formatarData(data) {
    if (!data) return '--';

    const partes = String(data).split('-');
    if (partes.length !== 3) return data;

    return `${partes[2]}/${partes[1]}/${partes[0]}`;
}

function formatarStatusPrazo(processo, viagem) {
    if (!viagem) return '--';

    if (viagem.status === 'programada' || processo.status === 'futuro') {
        return 'Previsto';
    }

    if (viagem.data_chegada_real && viagem.previsao_chegada_inicial) {
        const chegada = new Date(viagem.data_chegada_real);
        const prevista = new Date(viagem.previsao_chegada_inicial);
        return chegada <= prevista ? 'No prazo' : 'Atrasado';
    }

    if (viagem.status === 'em_curso' || processo.status === 'em_andamento') {
        return 'Em andamento';
    }

    return 'Previsto';
}

async function carregarHistoricoPrazos() {
    const { data: processos, error: erroProcessos } = await supabaseClient
        .from('processos')
        .select('*')
        .order('data_inicio_processo', { ascending: false });

    if (erroProcessos) throw erroProcessos;

    const { data: empresas, error: erroEmpresas } = await supabaseClient
        .from('empresas')
        .select('id_empresa, nome');

    if (erroEmpresas) throw erroEmpresas;

    const idsViagens = [...new Set((processos || []).map((p) => p.id_viagem))];
    let viagens = [];

    if (idsViagens.length > 0) {
        const respostaViagens = await supabaseClient
            .from('viagens')
            .select('*')
            .in('id_viagem', idsViagens);

        if (respostaViagens.error) throw respostaViagens.error;
        viagens = respostaViagens.data || [];
    }

    const empresasPorId = new Map((empresas || []).map((e) => [e.id_empresa, e]));
    const viagensPorId = new Map((viagens || []).map((v) => [v.id_viagem, v]));

    const tabela = document.getElementById('tabela-historico-prazos');
    if (!tabela) return;

    if (!processos || processos.length === 0) {
        tabela.innerHTML = '<tr><td colspan="3">Nenhum processo encontrado.</td></tr>';
        return;
    }

    tabela.innerHTML = processos.slice(0, 6).map((processo) => {
        const empresa = empresasPorId.get(processo.id_empresa);
        const viagem = viagensPorId.get(processo.id_viagem);
        const data = viagem?.data_chegada_real || viagem?.previsao_chegada_inicial || processo.data_inicio_processo;
        const status = formatarStatusPrazo(processo, viagem);

        return `
            <tr>
                <td>${empresa?.nome || processo.id_empresa}</td>
                <td>${formatarData(data)}</td>
                <td>${status}</td>
            </tr>
        `;
    }).join('');
}

async function carregarTopLocalidades() {
    const { data, error } = await supabaseClient
        .from('etapas_viagem')
        .select('local_etapa');

    if (error) throw error;

    const contagem = {};

    (data || []).forEach((etapa) => {
        const local = etapa.local_etapa || 'Não informado';
        contagem[local] = (contagem[local] || 0) + 1;
    });

    const localidades = Object.entries(contagem)
        .map(([localidade, total]) => ({ localidade, total }))
        .sort((a, b) => b.total - a.total)
        .slice(0, 5);

    const lista = document.getElementById('top-localidades');
    if (!lista) return;

    if (localidades.length === 0) {
        lista.innerHTML = '<li>Nenhuma localidade encontrada.</li>';
        return;
    }

    lista.innerHTML = localidades.map((item) => `
        <li>${item.localidade}</li>
    `).join('');
}

async function carregarDashboardGeral() {
    try {
        await carregarHistoricoPrazos();
        await carregarTopLocalidades();

        console.log('Dashboard geral carregado.');
    } catch (erro) {
        console.error('Erro ao carregar dashboard geral:', erro);
    }
}

// ----------- GRÁFICOS 
async function carregarGraficoCustosExtrasGeral() {
    const { data, error } = await supabaseClient
        .from("custos_extras")
        .select(`
            avarias,
            lavagem_container,
            armazenagem,
            dta,
            demurrage_custo,
            processos (
                data_inicio_processo
            )
        `);

    if (error) {
        console.log(error);
        return;
    }

    const custosPorMes = {};

    data.forEach(item => {
        const dataProcesso = item.processos.data_inicio_processo;
        const mes = dataProcesso.slice(0, 7);

        if (!custosPorMes[mes]) {
            custosPorMes[mes] = {
                avarias: 0,
                lavagem_container: 0,
                armazenagem: 0,
                dta: 0,
                demurrage: 0
            };
        }

        custosPorMes[mes].avarias += Number(item.avarias || 0);
        custosPorMes[mes].lavagem_container += Number(item.lavagem_container || 0);
        custosPorMes[mes].armazenagem += Number(item.armazenagem || 0);
        custosPorMes[mes].dta += Number(item.dta || 0);
        custosPorMes[mes].demurrage += Number(item.demurrage_custo || 0);
    });

    const meses = Object.keys(custosPorMes).sort();

    const labels = meses.map(mes => {
        const [ano, numeroMes] = mes.split("-");
        return `${numeroMes}/${ano}`;
    });

    const canvas = document.getElementById("canvas-custos-extras");

    new Chart(canvas, {
        type: "line",
        data: {
            labels: labels,
            datasets: [
                {
                    label: "Avarias",
                    data: meses.map(mes => custosPorMes[mes].avarias),
                    tension: 0.3
                },
                {
                    label: "Lavagem container",
                    data: meses.map(mes => custosPorMes[mes].lavagem_container),
                    tension: 0.3
                },
                {
                    label: "Armazenagem",
                    data: meses.map(mes => custosPorMes[mes].armazenagem),
                    tension: 0.3
                },
                {
                    label: "DTA",
                    data: meses.map(mes => custosPorMes[mes].dta),
                    tension: 0.3
                },
                {
                    label: "Demurrage",
                    data: meses.map(mes => custosPorMes[mes].demurrage),
                    tension: 0.3
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });
}

async function carregarGraficoRankingPaises() {
    const { data, error } = await supabaseClient
        .from("viagens")
        .select("pais_origem");

    if (error) {
        console.log(error);
        return;
    }

    const contagem = {};

    data.forEach(viagem => {
        const pais = viagem.pais_origem;

        if (!contagem[pais]) {
            contagem[pais] = 0;
        }

        contagem[pais]++;
    });

    const ranking = Object.entries(contagem)
        .map(([pais, total]) => ({ pais, total }))
        .sort((a, b) => b.total - a.total)
        .slice(0, 3);

    const podium = [ranking[1], ranking[0], ranking[2]];

    const labels = [
        `2º ${podium[0].pais}`,
        `1º ${podium[1].pais}`,
        `3º ${podium[2].pais}`
    ];

    const valores = [
        podium[0].total,
        podium[1].total,
        podium[2].total
    ];

    const canvas = document.getElementById("canvas-ranking-paises");

    new Chart(canvas, {
        type: "bar",
        data: {
            labels: labels,
            datasets: [{
                label: "Viagens (origem)",
                data: valores,
                borderRadius: 8
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });
}
// --------------------

document.addEventListener('DOMContentLoaded', () => {
    carregarDashboardGeral();
    carregarGraficoCustosExtrasGeral();
    carregarGraficoRankingPaises()
});