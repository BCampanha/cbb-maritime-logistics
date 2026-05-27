// Funções para o banco ----------------------------------------------------

const supabaseUrl = 'https://dafzthchjvglzrxjsewi.supabase.co';
const supabaseKey = 'sb_publishable_GfbL_TckwcfpDwl9D1Y_AA_CDfYdNRL'; // chave pública

const client = window.supabase.createClient(
    supabaseUrl,
    supabaseKey
);

console.log("Conexão com Supabase:", client); // confirma se está conectado

// Pega cliente da URL (ex: "dashboard2.html?cliente=magalu")
function pegarClienteDaURL() {
    const params = new URLSearchParams(window.location.search);
    return params.get("cliente");
}

async function carregarProcessosAtivos() {
    const emAndamento = await client.from("processos").select("*").eq("id_empresa", pegarClienteDaURL()).eq("status", "em_andamento");
    // const todos = await client.from("processos").select("*").eq("id_empresa", "amazon");
    console.log(emAndamento.data)
    document.getElementById("processos-ativos").textContent = emAndamento.data.length // + "/" + todos.data.length;
}


// Funções para a parte estética --------------------------------------------

// Muda cores e visualização do dashboard Financeiro/Operacional
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

// Muda estilo do cliente selecionado no menu lateral
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

document.addEventListener("DOMContentLoaded", () => {
    carregarProcessosAtivos();
});