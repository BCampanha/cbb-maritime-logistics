// Funções para menu lateral e parte estética

// Função para listar clientes no menu lateral
async function carregarClientesMenu() {
    const { data, error } = await supabaseClient
        .from("empresas")
        .select("id_empresa, nome")
        .order("nome");

    if (error) {
        console.log(error);
        return;
    }

    const params = new URLSearchParams(window.location.search);
    const clienteAtual = params.get("cliente");

    const lista = document.getElementById("lista-clientes");
    lista.innerHTML = "";

    data.forEach(cliente => {
        const classeAtiva = String(cliente.id_empresa) === clienteAtual ? "ativo" : "";

        lista.innerHTML += `
            <a class="li ${classeAtiva}" href="dashboard2.html?cliente=${cliente.id_empresa}">
                ${cliente.nome}
            </a>
        `;
    });
}

// Muda cores e visualização do dashboard Financeiro/Operacional
function ver(id) {
    const operacional = document.getElementById("operacional-especifico");
    const financeiro = document.getElementById("financeiro-especifico");

    const operacionalAba = document.getElementById("operacional-aba");
    const financeiroAba = document.getElementById("financeiro-aba");

    operacional.style.display = "none";
    financeiro.style.display = "none";

    operacionalAba.style.backgroundColor = "#84C2DD";
    financeiroAba.style.backgroundColor = "#84C2DD";

    document.getElementById(id + "-especifico").style.display = "flex";
    document.getElementById(id + "-aba").style.backgroundColor = "#B0D8E9";
}

// CHAMA FUNÇÕES
document.addEventListener("DOMContentLoaded", () => {
    carregarClientesMenu();
});