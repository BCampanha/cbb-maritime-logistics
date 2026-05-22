const supabaseUrl = 'https://dafzthchjvglzrxjsewi.supabase.co';
const supabaseKey = 'sb_publishable_GfbL_TckwcfpDwl9D1Y_AA_CDfYdNRL'; // chave pública

const client = window.supabase.createClient(
    supabaseUrl,
    supabaseKey
);

// função para listar empresas
async function carregarEmpresas() {

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

carregarEmpresas();