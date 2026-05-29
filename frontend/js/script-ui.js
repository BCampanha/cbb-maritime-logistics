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
    const financeiro = document.getElementById("financeiro-especifico");
    const financeiroAba = document.getElementById("financeiro-aba");
    const operacional = document.getElementById("operacional-especifico");
    const operacionalAba = document.getElementById("operacional-aba");
    const atual = document.getElementById(id+'-especifico');
    const atualAba = document.getElementById(id+'-aba');
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
    carregarClientesMenu();
});