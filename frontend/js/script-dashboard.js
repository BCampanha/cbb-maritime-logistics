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

document.addEventListener('DOMContentLoaded', carregarDashboardGeral);