// DASHBOARD ESPECÍFICO DO CLIENTE

// pega cliente da url
function pegarClienteDaURL() {
    const params = new URLSearchParams(window.location.search);
    return params.get('cliente') || 'amazon';
}

// funções auxiliares (formatação) ---------------------------------------------
function setTexto(id, valor) {
    const elemento = document.getElementById(id);
    if (elemento) {
        elemento.textContent = valor;
    }
    else {
        console.log("Erro. Não foi encontrado elemento com id ", id)
    }
}

function setTodos(id, valor) {
    document.querySelectorAll(`#${id}`).forEach((elemento) => {
        elemento.textContent = valor;
    });
}

function formatarMoeda(valor) {
    return Number(valor || 0).toLocaleString('pt-BR', {
        style: 'currency',
        currency: 'BRL'
    });
}

function formatarNumero(valor) {
    return Number(valor || 0).toLocaleString('pt-BR');
}

function formatarData(data) {
    if (!data) return '--';

    return new Date(data).toLocaleDateString('pt-BR', {
        timeZone: 'UTC'
    });
}

function formatarStatus(status) {
    const nomes = {
        em_andamento: 'Em andamento',
        finalizado: 'Finalizado',
        futuro: 'Futuro',
        finalizada: 'Finalizada',
        em_curso: 'Em curso',
        programada: 'Programada',
        pago: 'Pago',
        pendente: 'Pendente',
        vencido: 'Vencido',
        aberta: 'Aberta',
        resolvida: 'Resolvida',
        processado: 'Processado',
        em_analise: 'Em análise'
    };

    return nomes[status] || status || '--';
}

function diferencaDias(dataInicial, dataFinal) {
    if (!dataInicial || !dataFinal) return null;

    const inicio = new Date(dataInicial);
    const fim = new Date(dataFinal);

    if (Number.isNaN(inicio.getTime()) || Number.isNaN(fim.getTime())) {
        return null;
    }

    const msPorDia = 1000 * 60 * 60 * 24;
    return Math.round((fim - inicio) / msPorDia);
}

function somarCampo(lista, campo) {
    return lista.reduce((total, item) => total + Number(item[campo] || 0), 0);
}

function obterIdsProcessos(processos) {
    return processos.map((processo) => processo.id_processo);
}
// fim das funções auxiliares ----------------------------------------------------



// funções para preencher o dashboard --------------------------------------------

async function buscarDadosCliente(idEmpresa) {
    const { data: empresa, error: erroEmpresa } = await supabaseClient
        .from('empresas')
        .select('*')
        .eq('id_empresa', idEmpresa)
        .maybeSingle();

    if (erroEmpresa) throw erroEmpresa;

    const { data: processos, error: erroProcessos } = await supabaseClient
        .from('processos')
        .select('*')
        .eq('id_empresa', idEmpresa)
        .order('id_processo');

    if (erroProcessos) throw erroProcessos;

    const idsProcessos = obterIdsProcessos(processos || []);
    const idsViagens = [...new Set((processos || []).map((p) => p.id_viagem))];

    let viagens = [];
    if (idsViagens.length > 0) {
        const resposta = await supabaseClient
            .from('viagens')
            .select('*')
            .in('id_viagem', idsViagens);

        if (resposta.error) throw resposta.error;
        viagens = resposta.data || [];
    }

    let custos = [];
    let eventos = [];

    if (idsProcessos.length > 0) {
        const respostaCustos = await supabaseClient
            .from('custos_extras')
            .select('*')
            .in('id_processo', idsProcessos);

        if (respostaCustos.error) throw respostaCustos.error;
        custos = respostaCustos.data || [];

        const respostaEventos = await supabaseClient
            .from('eventos_processo')
            .select('*')
            .in('id_processo', idsProcessos);

        if (respostaEventos.error) throw respostaEventos.error;
        eventos = respostaEventos.data || [];
    }

    return {
        empresa,
        processos: processos || [],
        viagens,
        custos,
        eventos
    };
}

function preencherCardsOperacionais(dados) {
    const processosAtivos = dados.processos.filter((p) => p.status === 'em_andamento').length;
    setTexto('processos-ativos', processosAtivos);

    const ocorrenciasAbertas = dados.eventos.filter(
        (e) => e.tipo_evento === 'ocorrencia' && e.status === 'aberta'
    ).length;
    setTexto('ocorrencias-abertas', ocorrenciasAbertas);

    const documentos = dados.eventos.filter((e) => e.tipo_evento === 'documento');
    const docsProcessados = documentos.filter((e) => e.status === 'processado').length;
    const percentualDocs = documentos.length > 0
        ? Math.round((docsProcessados / documentos.length) * 100)
        : 0;

    setTodos('docs-processados', `${percentualDocs}%`);

    const viagensPorId = new Map(dados.viagens.map((v) => [v.id_viagem, v]));
    const dias = dados.processos
        .map((processo) => {
            const viagem = viagensPorId.get(processo.id_viagem);
            if (!viagem) return null;

            const inicio = viagem.data_saida || processo.data_inicio_processo;
            const fim = viagem.data_chegada_real || viagem.previsao_chegada_inicial;
            return diferencaDias(inicio, fim);
        })
        .filter((valor) => valor !== null);

    const mediaDias = dias.length > 0
        ? Math.round(dias.reduce((soma, valor) => soma + valor, 0) / dias.length)
        : 0;

    setTexto('dias-media', mediaDias);
}

function escolherProcessoDaRota(processos) {
    return (
        processos.find((p) => p.status === 'em_andamento') ||
        processos.find((p) => p.status === 'finalizado') ||
        processos[0]
    );
}

async function preencherRota(dados) {
    const processoRota = escolherProcessoDaRota(dados.processos);
    if (!processoRota) return;

    const viagem = dados.viagens.find((v) => v.id_viagem === processoRota.id_viagem);
    if (!viagem) return;

    const { data: etapas, error } = await supabaseClient
        .from('etapas_viagem')
        .select('*')
        .eq('id_viagem', viagem.id_viagem)
        .order('numero_etapa');

    if (error) throw error;

    setTexto('rota-porto-origem', viagem.porto_origem || '--');
    setTexto('rota-pais-origem', `${viagem.pais_origem || '--'} - Origem`);
    setTexto('rota-porto-destino', viagem.porto_destino || '--');
    setTexto('rota-pais-destino', `${viagem.pais_destino || '--'} - Destino`);

    const etapasEncontradas = etapas || [];
    const etapaAtual = etapasEncontradas.length > 0
        ? etapasEncontradas[etapasEncontradas.length - 1].local_etapa
        : '--';

    setTexto('rota-atual', etapaAtual);
    setTexto(
    'rota-atual-complemento',
    `Partida: ${formatarData(viagem.data_saida)} | Previsão Conclusão: ${formatarData(viagem.previsao_chegada_inicial)}`
    );
    setTexto('km-distancia', formatarNumero(viagem.distancia_km || 0));

    const diasTransito = diferencaDias(
        viagem.data_saida || processoRota.data_inicio_processo,
        viagem.data_chegada_real || viagem.previsao_chegada_inicial
    );

    setTexto('tempo-transito', diasTransito !== null ? `${diasTransito} dias` : '--');
    setTexto('escalas', etapasEncontradas.length);
    setTexto('status', formatarStatus(viagem.status));

}

function preencherOcorrencias(dados) {
    const ocorrencias = dados.eventos.filter((e) => e.tipo_evento === 'ocorrencia');
    const abertas = ocorrencias.filter((e) => e.status === 'aberta');

    const avarias = abertas.filter((e) => e.subtipo === 'avaria').length;
    const extravio =  abertas.filter((e) => e.subtipo === 'extravio').length;
    const atraso = abertas.filter((e) => e.subtipo === 'atraso').length;

    setTexto('num-ocorrencias', abertas.length);
    setTexto('num-avarias', avarias);
    setTexto('num-extravio', extravio);
    setTexto('num-atraso', atraso);

    const totalTiposOcorrencias = avarias + extravio + atraso;

    preencherBarra("barra-avarias", avarias, totalTiposOcorrencias);
    preencherBarra("barra-extravio", extravio, totalTiposOcorrencias);
    preencherBarra("barra-atraso", atraso, totalTiposOcorrencias);
}

function preencherDocumentos(dados) {
    const documentos = dados.eventos.filter((e) => e.tipo_evento === 'documento');
    const total = documentos.length;

    function percentual(status) {
        if (total === 0) return '0%';
        const quantidade = documentos.filter((e) => e.status === status).length;
        return Math.round((quantidade / total) * 100);
    }

    setTodos('docs-processados', `${percentual('processado')}%`);
    setTexto('docs-em-analise', `${percentual('em_analise')}%`);
    setTexto('docs-pendentes', `${percentual('pendente')}%`);

    preencherBarra("barra-docs-processados", percentual('processado'), 100);
    preencherBarra("barra-docs-em-analise", percentual('procesem_analisesado'), 100);
    preencherBarra("barra-docs-pendentes", percentual('pendente'), 100);
}

function preencherCardsFinanceiros(dados) {
    const totalAvarias = somarCampo(dados.custos, 'avarias');
    const totalLavagem = somarCampo(dados.custos, 'lavagem_container');
    const totalArmazenagem = somarCampo(dados.custos, 'armazenagem');
    const totalDta = somarCampo(dados.custos, 'dta');
    const totalDemurrage = somarCampo(dados.custos, 'demurrage_custo');

    const totalCustosExtras = totalAvarias + totalLavagem + totalArmazenagem + totalDta + totalDemurrage;

    const faturamento = dados.processos.reduce(
        (total, processo) => total + Number(processo.numerario_cotacao || 0),
        0
    );

    setTexto('total-custos-extras', formatarMoeda(totalCustosExtras));
    setTexto('custos-armazenagem', formatarMoeda(totalArmazenagem));
    setTexto('custos-estadia', formatarMoeda(totalDemurrage));

    // O banco atual não tem uma coluna direta de valor faturado em processos.
    // A tabela de faturamento abaixo busca a taxa na tabela cotacoes_cliente.
    // Este card será atualizado corretamente depois da busca das cotações.
    setTexto('faturamento-processo', formatarMoeda(faturamento));
}

async function preencherFaturamento(dados) {
    const numerarios = [...new Set(dados.processos.map((p) => p.numerario_cotacao))];
    let cotacoes = [];

    if (numerarios.length > 0) {
        const { data, error } = await supabaseClient
            .from('cotacoes_cliente')
            .select('*')
            .in('numerario_cotacao', numerarios);

        if (error) throw error;
        cotacoes = data || [];
    }

    const cotacoesPorNumero = new Map(cotacoes.map((c) => [c.numerario_cotacao, c]));
    const faturamentoTotal = dados.processos.reduce((total, processo) => {
        const cotacao = cotacoesPorNumero.get(processo.numerario_cotacao);
        return total + Number(cotacao?.taxa || 0);
    }, 0);

    setTexto('faturamento-processo', formatarMoeda(faturamentoTotal));

    const tabela = document.getElementById('tabela-faturamento');
    if (!tabela) return;

    if (dados.processos.length === 0) {
        tabela.innerHTML = '<tr><td colspan="3">Nenhum processo encontrado.</td></tr>';
        return;
    }

    const idEmpresa = pegarClienteDaURL().toUpperCase();

    tabela.innerHTML = dados.processos.map((processo) => {
        const cotacao = cotacoesPorNumero.get(processo.numerario_cotacao);
        const codigo = `${idEmpresa}-${new Date(processo.data_inicio_processo).getFullYear()}-${String(processo.id_processo).padStart(3, '0')}`;

        return `
            <tr>
                <td>${codigo}</td>
                <td>${formatarMoeda(cotacao?.taxa || 0)}</td>
                <td>${formatarStatus(processo.status_faturamento)}</td>
            </tr>
        `;
    }).join('');
}

function preencherDemurrage(dados) {
    const dias = somarCampo(dados.custos, 'demurrage_dias');
    const custoTotal = somarCampo(dados.custos, 'demurrage_custo');
    const precoMedio = dias > 0 ? custoTotal / dias : 0;

    const containers = dados.eventos
        .filter((e) => e.tipo_evento === 'container')
        .reduce((total, evento) => total + Number(evento.quantidade || 0), 0);

    setTexto('demurrage-dias-totais', dias);
    setTexto('demurrage-preco-medio', `${formatarMoeda(precoMedio)}/dia`);
    setTexto('demurrage-custo-total', formatarMoeda(custoTotal));
    setTexto('demurrage-containers', containers);
}

function preencherArmazenagem(dados) {
    const eventosDias = dados.eventos.filter(
        (e) => e.tipo_evento === 'armazenagem' && e.subtipo === 'dias'
    );

    const dias = eventosDias.reduce((total, evento) => total + Number(evento.quantidade || 0), 0);
    const custoTotal = somarCampo(dados.custos, 'armazenagem');
    const precoMedio = dias > 0 ? custoTotal / dias : 0;

    const armazens = new Set(
        dados.eventos
            .filter((e) => e.tipo_evento === 'armazenagem' && e.subtipo === 'armazem')
            .map((e) => e.descricao)
            .filter(Boolean)
    ).size;

    setTexto('armazenagem-dias-totais', dias);
    setTexto('armazenagem-preco-medio', `${formatarMoeda(precoMedio)}/dia`);
    setTexto('armazenagem-custo-total', formatarMoeda(custoTotal));
    setTexto('armazenagem-armazens', armazens);
}

async function carregarDashboardCliente() {
    try {
        const idEmpresa = pegarClienteDaURL();
        const dados = await buscarDadosCliente(idEmpresa);

        preencherCardsOperacionais(dados);
        await preencherRota(dados);
        preencherOcorrencias(dados);
        preencherDocumentos(dados);
        preencherCardsFinanceiros(dados);
        await preencherFaturamento(dados);
        preencherDemurrage(dados);
        preencherArmazenagem(dados);

        console.log('Dashboard específico carregado:', dados);
    } catch (erro) {
        console.error('Erro ao carregar dashboard específico:', erro);
    }
}


// GRÁFICOS ---------------------------------------------------------------
// Carrega os gráficos de custos extras do cliente selecionado
async function carregarGraficosCustosExtrasCliente() {
    const cliente = pegarClienteDaURL();

    const { data, error } = await supabaseClient
        .from("custos_extras")
        .select(`
            avarias,
            lavagem_container,
            armazenagem,
            dta,
            demurrage_custo,
            processos (
                id_empresa,
                data_inicio_processo
            )
        `)
        .eq("processos.id_empresa", cliente);

    if (error) {
        console.log(error);
        return;
    }

    const custosPorMes = {};

    data.forEach(item => {
        if (!item.processos) return;

        const mes = item.processos.data_inicio_processo.slice(0, 7);

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

    const datasets = [
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
    ];

    document.querySelectorAll(".canvas-custos-extras-cliente").forEach(canvas => {
        new Chart(canvas, {
            type: "line",
            data: {
                labels: labels,
                datasets: datasets
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });
    });
}

function preencherBarra(id, valor, total) {
    const barra = document.getElementById(id);

    if (!barra) return;

    const percentual = total > 0 ? (valor / total) * 100 : 0;

    barra.style.width = percentual + "%";
}

document.addEventListener('DOMContentLoaded', () => {
    carregarDashboardCliente();
    carregarGraficosCustosExtrasCliente();
})