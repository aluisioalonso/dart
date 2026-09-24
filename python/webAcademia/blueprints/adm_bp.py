from flask import Blueprint, render_template, request, session
from dao.usuarioDAO import dao_usuario

admin_bp = Blueprint('admin_blueprint', __name__)


@admin_bp.route("/admin")
def painel_adm():
    if 'usuario_logado' not in session or session['usuario_logado'] != 'admin':
        return render_template('login.html')

    lista_usuarios = dao_usuario.listar_todos()
    lista_planos = dao_usuario.listar_planos()
    return render_template("pgAdm.html", usuarios=lista_usuarios, planos=lista_planos)


@admin_bp.route("/admin/cadastrar_plano", methods=["POST"])
def cadastrar_plano():
    if 'usuario_logado' not in session or session['usuario_logado'] != 'admin':
        return render_template('login.html')

    nome_plano = request.form.get("nome_plano")
    preco_plano = request.form.get("preco_plano")

    if nome_plano and preco_plano:
        dao_usuario.cadastrar_plano(nome_plano, preco_plano)

    lista_usuarios = dao_usuario.listar_todos()
    lista_planos = dao_usuario.listar_planos()
    return render_template("pgAdm.html", usuarios=lista_usuarios, planos=lista_planos)


@admin_bp.route("/admin/remover/<login>")
def remover_usuario(login):
    if 'usuario_logado' not in session or session['usuario_logado'] != 'admin':
        return render_template('login.html')

    dao_usuario.remover(login)

    lista_usuarios = dao_usuario.listar_todos()
    lista_planos = dao_usuario.listar_planos()
    return render_template("pgAdm.html", usuarios=lista_usuarios, planos=lista_planos)


@admin_bp.route("/admin/mensalidade/<login>/<status>")
def alterar_mensalidade(login, status):
    if 'usuario_logado' not in session or session['usuario_logado'] != 'admin':
        return render_template('login.html')

    dao_usuario.alterar_status_mensalidade(login, status)

    lista_usuarios = dao_usuario.listar_todos()
    lista_planos = dao_usuario.listar_planos()
    return render_template("pgAdm.html", usuarios=lista_usuarios, planos=lista_planos)




@admin_bp.route('/admin/remover_plano/<nome_plano>')
def remover_plano(nome_plano):
    con = obter_conexao()
    cursor = con.cursor()
    cursor.execute("DELETE FROM planos WHERE nome = ?", (nome_plano,))
    con.commit()
    con.close()

    print(f"Plano para remover: {nome_plano}")  # Apenas para você ver no terminal

    # Redireciona de volta para o painel do administrador atualizado
    # Se a rota do seu painel for só '/', mude para redirect('/')
    return render_template('/admin')