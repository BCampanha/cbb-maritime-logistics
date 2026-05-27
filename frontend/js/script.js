const supabaseUrl = 'https://dafzthchjvglzrxjsewi.supabase.co';
const supabaseKey = 'sb_publishable_GfbL_TckwcfpDwl9D1Y_AA_CDfYdNRL'; // chave pública

const client = window.supabase.createClient(
    supabaseUrl,
    supabaseKey
);

// função para carregar Dashboard
async function carregarDashboard() {

    // seleciona todos os resultados da tabela kpi_dashboard (calculada pelo python)
    const { data, error } = await client
        .from('kpis_dashboard')
        .select('*');

    if (error) {
        console.log(error);
        return;
    }

    console.log(data);

    // pega a div com id resultado
    const div = document.getElementById('resultado');

    // cria um novo parágrafo com os resultados esperados
    
    // 1. Lista de kpis
    const kpis = {};
    data.forEach(item => {
        kpis[item.chave] = item.valor;
    });

    div.innerHTML = `
        <p>
            <strong>Total de custos extras: R$ ${kpis.total_custos_extras}</strong>
            - Total de processos: ${kpis.total_processos}
        </p>
    `;
}

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

    // Exemplo: trocar título
    const titulo = document.querySelector("#cliente-nome");

    if (titulo) {
        titulo.textContent = clienteAtual.toUpperCase();
    }
});


carregarDashboard();
