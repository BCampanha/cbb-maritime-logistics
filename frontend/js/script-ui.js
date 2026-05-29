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

// ----------- GRÁFICOS 
function carregarGraficoCustosExtrasTeste() {
    const canvas = document.getElementById("canvas-custos-extras");

    new Chart(canvas, {
        type: "line",
        data: {
            labels: ["Jan", "Fev", "Mar", "Abr", "Mai"],
            datasets: [
                {
                    label: "Avarias",
                    data: [5000, 8000, 3000, 7000, 4000],
                    tension: 0.3
                },
                {
                    label: "Lavagem container",
                    data: [2000, 1500, 2500, 3000, 1800],
                    tension: 0.3
                },
                {
                    label: "Armazenagem",
                    data: [9000, 12000, 8000, 15000, 10000],
                    tension: 0.3
                },
                {
                    label: "DTA",
                    data: [3000, 4000, 2000, 5000, 3500],
                    tension: 0.3
                },
                {
                    label: "Demurrage",
                    data: [10000, 18000, 7000, 22000, 16000],
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

function carregarRankingPaisesTeste() {
    const canvas = document.getElementById("canvas-ranking-paises");

    new Chart(canvas, {
        type: "bar",
        data: {
            labels: [
                "2º\nEUA",
                "1º\nChina",
                "3º\nCanadá"
            ],
            datasets: [{
                label: "Processos",
                data: [7, 12, 4],
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


// CHAMA FUNÇÕES
document.addEventListener("DOMContentLoaded", () => {
    carregarClientesMenu();
    carregarGraficoCustosExtrasTeste();
    carregarRankingPaisesTeste()
});