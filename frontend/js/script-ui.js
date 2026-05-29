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