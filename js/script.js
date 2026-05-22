const supabaseUrl = 'https://dafzthchjvglzrxjsewi.supabase.co';
const supabaseKey = 'sb_publishable_GfbL_TckwcfpDwl9D1Y_AA_CDfYdNRL'; // chave pública

const client = window.supabase.createClient(
    supabaseUrl,
    supabaseKey
);

// função para listar empresas
async function carregarEmpresas() {

    // seleciona todos os resultados da tabela empresa
    const { data, error } = await client
        .from('empresas')
        .select('*');

    if (error) {
        console.log(error);
        return;
    }

    console.log(data);

    // pega a div com id resultado
    const div = document.getElementById('resultado');

    // cria um novo parágrafo com o nome da empresa e a categoria, para cada linha do resultado
    data.forEach(empresa => {

        div.innerHTML += `
            <p>
                <strong>${empresa.nome}</strong>
                - ${empresa.categoria}
            </p>
        `;
    });
}

carregarEmpresas();