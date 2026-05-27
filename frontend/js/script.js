const supabaseUrl = 'https://dafzthchjvglzrxjsewi.supabase.co';
const supabaseKey = 'sb_publishable_GfbL_TckwcfpDwl9D1Y_AA_CDfYdNRL'; // chave pública

const client = window.supabase.createClient(
    supabaseUrl,
    supabaseKey
);

// Utilitários 
 
function fmt(valor) {
    return 'R$ ' + Number(valor).toLocaleString('pt-BR', { minimumFractionDigits: 2 });
}
 
function parseJson(str) {
    try { return JSON.parse(str); } catch { return null; }
}
 
// Paleta de cores CBB 
const COR = {
    azul:        'yellow',
    azulMedio:   'orange',
    azulClaro:   'blue',
    azulPalido:  'gray',
    branco:      '#000000',
    cinza:       'green',
};
 
// Cores para gráficos de pizza / rosca
const PIZZA_CORES = [
    COR.azul,
    COR.azulMedio,
    COR.azulClaro,
    COR.azulPalido,
    'pink',
];
 
// Carregar e renderizar Dashboard 
async function carregarDashboard() {
    const { data, error } = await client.from('kpis_dashboard').select('*');
    if (error) { console.error('Erro ao carregar KPIs:', error); return; }
 
    // Monta dicionário chave -> valor / descricao
    const kpis = {};
    data.forEach(item => {
        kpis[item.chave] = { valor: item.valor, desc: item.descricao };
    });
 
    const v = (chave) => kpis[chave]?.valor ?? 0;
    const j = (chave) => parseJson(kpis[chave]?.desc) ?? [];
 
    //  Atualiza cards de texto 
 
    // DASHBOARD GERAL (dashboard.html)
    setText('kpi-total-custos',   fmt(v('total_custos_extras')));
    setText('kpi-total-processos', v('total_processos'));
 
    // DASHBOARD CLIENTE (dashboard2.html) - Operacional
    setText('kpi-processos-ativos', v('total_processos'));
    setText('kpi-ocorrencias',      v('total_ocorrencias'));
    setText('kpi-docs-pct',         v('docs_processados') + '%');
    setText('kpi-dias-medio',       v('dias_medio_processo'));
 
    // Barra de ocorrências
    setBarProgress('bar-avarias',  v('ocorrencias_avarias'),  v('total_ocorrencias'));
    setBarProgress('bar-extravio', v('ocorrencias_extravio'), v('total_ocorrencias'));
    setBarProgress('bar-atraso',   v('ocorrencias_atraso'),   v('total_ocorrencias'));
    setText('num-avarias',  v('ocorrencias_avarias'));
    setText('num-extravio', v('ocorrencias_extravio'));
    setText('num-atraso',   v('ocorrencias_atraso'));
 
    // Barra de documentos
    const totalProc = v('total_processos') || 1;
    const pctProcessados = Math.round((v('docs_processados') / totalProc) * 100);
    const pctAnalise     = Math.round((v('docs_analise')     / totalProc) * 100);
    const pctPendentes   = 100 - pctProcessados - pctAnalise;
    setBarProgress('bar-docs-processados', pctProcessados, 100);
    setBarProgress('bar-docs-analise',     pctAnalise,     100);
    setBarProgress('bar-docs-pendentes',   pctPendentes,   100);
    setText('num-docs-processados', pctProcessados + '%');
    setText('num-docs-analise',     pctAnalise     + '%');
    setText('num-docs-pendentes',   pctPendentes   + '%');
 
    // DASHBOARD CLIENTE - Financeiro
    setText('kpi-total-extras-fin',  fmt(v('total_custos_extras')));
    setText('kpi-faturamento',       fmt(v('total_faturamento')));
    setText('kpi-armazenagem-fin',   fmt(v('total_armazenagem')));
    setText('kpi-demurrage-fin',     fmt(v('total_demurrage')));
 
    // Demurrage detalhes
    setText('dem-dias',         v('demurrage_dias_total'));
    setText('dem-preco',        'R$' + Math.round(v('demurrage_preco_medio')) + '/dia');
    setText('dem-custo',        fmt(v('total_demurrage')));
    setText('dem-containers',   v('demurrage_containers'));
 
    // Armazenagem detalhes
    setText('arm-dias',         v('armazenagem_dias'));
    setText('arm-preco',        'R$' + v('armazenagem_preco_medio') + '/dia');
    setText('arm-custo',        fmt(v('total_armazenagem')));
    setText('arm-armazens',     v('armazenagem_armazens'));
 
    // Tabela de faturamento
    const fatTab = j('fat_processos_json');
    renderTabelaFaturamento('tabela-faturamento', fatTab);
 
    //  Gráficos ─
 
    // 1. Gráfico de linha - Custos extras por mês (aparece nos dois dashboards)
    const meses   = j('custos_mes_labels');
    const valores  = j('custos_mes_valores');
    renderLinhaChart('chart-custos-linha',    meses, valores);
    renderLinhaChart('chart-custos-linha-op', meses, valores);
 
    // 2. Gráfico de barras - Ranking de países (dashboard geral)
    const paises   = j('ranking_paises_labels');
    const viagens  = j('ranking_paises_valores');
    renderBarrasChart('chart-ranking-paises', paises, viagens);
 
    // 3. Gráfico de pizza - Distribuição de custos (dashboard cliente / financeiro)
    renderPizzaChart('chart-distribuicao', [
        v('pct_avarias'),
        v('pct_armazenagem'),
        v('pct_demurrage'),
        v('pct_dta'),
        v('pct_lavagem'),
    ], ['Avarias', 'Armazenagem', 'Demurrage', 'DTA', 'Lavagem']);
}
 
// Helpers DOM / Chart 
 
function setText(id, val) {
    const el = document.getElementById(id);
    if (el) el.textContent = val;
}
 
function setBarProgress(id, valor, total) {
    const el = document.getElementById(id);
    if (!el) return;
    const pct = total > 0 ? Math.min(100, Math.round((valor / total) * 100)) : 0;
    el.style.width = pct + '%';
}

// Mapa para rastrear instâncias de gráficos
const chartInstances = {};

// Chart.js é carregado no HTML. Se não estiver disponível, renderiza mensagem.
function canvasOk(id) {
    return typeof Chart !== 'undefined' && document.getElementById(id);
}
 
function chartDefaults() {
    return {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                labels: { color: COR.branco, font: { size: 11 } }
            },
            tooltip: {
                callbacks: {
                    label: ctx => ' ' + Number(ctx.parsed.y ?? ctx.parsed).toLocaleString('pt-BR')
                }
            }
        }
    };
}
 
function renderLinhaChart(id, labels, dados) {
    if (!canvasOk(id)) return;
    if (!labels || labels.length === 0 || !dados || dados.length === 0) return;
    
    if (chartInstances[id]) {
        chartInstances[id].destroy();
    }
    
    const ctx = document.getElementById(id).getContext('2d');
    chartInstances[id] = new Chart(ctx, {
        type: 'line',
        data: {
            labels,
            datasets: [{
                label: 'Custos (R$)',
                data: dados,
                borderColor: COR.azulClaro,
                backgroundColor: 'rgba(132,194,221,0.15)',
                borderWidth: 2,
                pointBackgroundColor: COR.azulClaro,
                pointRadius: 4,
                tension: 0.35,
                fill: true,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    labels: { color: COR.branco, font: { size: 11 } }
                }
            },
            scales: {
                x: { ticks: { color: COR.azulPalido, font: { size: 10 } }, grid: { color: 'rgba(255,255,255,0.08)' } },
                y: { ticks: { color: COR.azulPalido, font: { size: 10 } }, grid: { color: 'rgba(255,255,255,0.08)' } }
            }
        }
    });
}
 
function renderBarrasChart(id, labels, dados) {
    if (!canvasOk(id)) return;
    
    // Destroi gráfico anterior se existir
    if (chartInstances[id]) {
        chartInstances[id].destroy();
    }
    
    const ctx = document.getElementById(id).getContext('2d');
    chartInstances[id] = new Chart(ctx, {
        type: 'bar',
        data: {
            labels,
            datasets: [{
                label: 'Viagens',
                data: dados,
                backgroundColor: PIZZA_CORES,
                borderRadius: 6,
                borderSkipped: false,
            }]
        },
        options: {
            ...chartDefaults(),
            indexAxis: 'y',
            plugins: { legend: { display: false } },
            scales: {
                x: { ticks: { color: COR.azulPalido, font: { size: 10 } }, grid: { color: 'rgba(255,255,255,0.08)' } },
                y: { ticks: { color: COR.branco,     font: { size: 11 } }, grid: { display: false } }
            }
        }
    });
}
 
function renderPizzaChart(id, dados, labels) {
    if (!canvasOk(id)) return;
    
    // Destroi gráfico anterior se existir
    if (chartInstances[id]) {
        chartInstances[id].destroy();
    }
    
    const ctx = document.getElementById(id).getContext('2d');
    chartInstances[id] = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels,
            datasets: [{
                data: dados,
                backgroundColor: PIZZA_CORES,
                borderColor: 'transparent',
                hoverOffset: 8,
            }]
        },
        options: {
            ...chartDefaults(),
            cutout: '60%',
            plugins: {
                legend: { position: 'bottom', labels: { color: COR.branco, font: { size: 11 }, padding: 12 } },
                tooltip: { callbacks: { label: ctx => ` ${ctx.label}: ${ctx.parsed}%` } }
            }
        }
    });
}
 
function renderTabelaFaturamento(id, linhas) {
    const tbody = document.getElementById(id);
    if (!tbody || !linhas?.length) return;
    tbody.innerHTML = linhas.map(l => {
        const statusClass = l.status === 'Pago' ? 'status-pago' : l.status === 'Pendente' ? 'status-pendente' : 'status-vencido';
        return `<tr>
            <td>P-${l.id_processo}</td>
            <td>${fmt(l.taxa)}</td>
            <td><span class="${statusClass}">${l.status}</span></td>
        </tr>`;
    }).join('');
}
 
// Abas (operacional / financeiro) ─

function ver(id) {
    const financeiro = document.getElementById("financeiro-especifico");
    const financeiroAba = document.getElementById("financeiro-aba");
    const operacional = document.getElementById("operacional-especifico");
    const operacionalAba = document.getElementById("operacional-aba");
    const atual = document.getElementById(id+'-especifico');
    const atualAba = document.getElementById(id+'-aba');
    console.log(id)
    if (atual.style.display === 'none') {
        operacional.style.display = 'none'; 
        financeiro.style.display = 'none';
        financeiroAba.style.backgroundColor = '#84C2DD';
        operacionalAba.style.backgroundColor = '#84C2DD';
        atual.style.display = 'flex';
        atualAba.style.backgroundColor = '#B0D8E9';
    }
}

// Destaque de cliente ativo na sidebar ─

document.addEventListener("DOMContentLoaded", () => {
    const params = new URLSearchParams(window.location.search);
    const clienteAtual = params.get("cliente");

    if (!clienteAtual) return;

    document.querySelectorAll("#menu-lateral .li").forEach(link => {
        const url = new URL(link.href, window.location.origin);

        if (url.searchParams.get("cliente") === clienteAtual) {
            link.classList.add("ativo");
        }
    });
});


// Init ─

carregarDashboard();
