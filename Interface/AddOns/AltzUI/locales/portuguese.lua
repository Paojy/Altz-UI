local T, C, L, G = unpack(select(2, ...))
if G.Client ~= "ptBR" then return end -- AltzUI - Brazilian Portuguese

L["团队工具"] = "Ferramentas de Raide"

L["当前经验"] = "Atual: "
L["剩余经验"] = "Restante: "
L["双倍"] = "Descansado: "
L["声望"] = "Reputação:"
L["剩余声望"] = "Restante: "
L["占用前 %d 的插件"] = "Top %d AddOns"
L["自定义插件占用"] = "Memória usada na UI"
L["所有插件占用"] = "Total incl. Blizzard UI"

L["Fire!"] = "Fire!"

L["赚得"] = "Ganho:"
L["消费"] = "Gasto:"
L["赤字"] = "Perda:"
L["盈利"] = "Lucro:"
L["本次登陆"] = "Sessão"
L["服务器"] = "Servidor"
L["角色"] = "Personagem"
L["重置金币信息"] = "Clique para restaurar."

L["脱装备"] = "Despir-se"
L["切天赋"] = "Alternar especialização ativa"

L["锁定框体"] = "Travar quadros"
L["解锁框体"] = "Destravar quadros"
L["重置框体位置"] = "Restaurar posições"

L["你不能在战斗中绑定按键"] = "Você não pode vincular teclas em combate."
L["按键绑定解除"] = "Vinculações de teclas retauradas ao padrão"
L["所有键位设定保存"] = "Todas as vinculações de teclas foram salvas."
L["刚才的键位设定修改取消了"] = "Todas as vinculações de teclas foram descartadas."
L["绑定到"] = "vinculado ao"
L["绑定模式"] = "Passe seu mouse em cima de qualquer botão para vincula-lo. Pressione tecla de espaço ou clique direito para limpar a tecla atualmente vinculada."
L["没有绑定键位"] = "Nenhuma tecla vinculada."
L["绑定"] = "Vinculações"
L["键位"] = "Tecla"
L["保存键位"] = "Salvar vinculações"
L["取消键位"] = "Descartar vinculações"

L["被闷了"] = "Sapped!"
L["被闷了2"] = "Sapped por:"

L["修理花费"] = "Custo do reparo:"

L["整理"] = "A"
L["背包"] = "M"

L["复制名字"] = "Copiar nome"
L["玩家详情"] = "Quem"
L["公会邀请"] = "Convidar para guilda"
L["添加好友"] = "Adicionar amigo"

L["信息条"] = "Barra de informações"
L["微型菜单"] = "MicroMenu"
L["控制台"] = "Configurações"
L["主动作条"] = "Barra de ações\nprincipal"
L["额外动作条"] = "Barra de ações\nadicional"
L["右侧额外动作条"] = "Barra de ações\nadicional direita"
L["宠物动作条"] = "Barra de ações do ajudante"
L["姿态/形态条"] = "Barra de postura"
L["离开载具按钮"] = "Sair do\nVeículo"
L["额外特殊按钮"] = "Barra de ações\nExtra" --
L["增益框"] = "Buff"
L["减益框"] = "Debuff"
L["ROLL点框"] = "Saque do Grupo"
L["鼠标提示"] = "Dicas de\ninterface"
L["承受伤害"] = "Texto de cura\nrecebida"
L["承受治疗"] = "Texto de dano\nrecebido"
L["输出伤害"] = "Texto de cura\ncausado"
L["输出治疗"] = "Texto de dano\ncausado"
L["任务追踪"] = "Quadro de missões"
L["小地图缩放按钮"] = "Minimap\nToggle Button"
L["聊天框缩放按钮"] = "Botão de alternância\nquadro de bate-papo"
L["背包框"] = "Quadro da mochila"
L["银行框"] = "Quadro do banco"
L["输出模式团队框架"] = "Dps/Tanque\nquadro de raide"
L["输出模式宠物团队框架"] = "Dps/Tanque\nPet\nquadro de raide"
L["治疗模式团队框架"] = "Cura\nquadro de raide"
L["治疗模式宠物团队框架"] = "Cura\najudante\nquadro de raide"
L["玩家头像"] = "Quadro do jogador"
L["宠物头像"] = "Quadro do ajudante"
L["目标头像"] = "Quadro do alvo"
L["目标的目标头像"] = "Quadro AdA"
L["焦点头像"] = "Quadro de foco"
L["焦点的目标头像"] = "ToF Frame"
for i = 1, MAX_BOSS_FRAMES do
	L["首领头像"..i] = "Chefe"..i
end
for i = 1, 5 do
	L["竞技场敌人头像"..i] = "Arena"..i
end
L["玩家施法条"] = "Barra de lançamento do jogador"
L["目标施法条"] = "Barra de lançamento do alvo"
L["焦点施法条"] = "Barra de lançamento do foco"
L["玩家平砍计时条"] = "Tempo de balanço do jogador"
L["冷却提示"] = "Alerta de recarga"
L["图腾条"] = "Barra de totem"
L["便捷物品按钮"] = "Botões de itens conveniêntes"
L["多人坐骑控制框"] = "Indicador de assento do veículo"
L["耐久提示框"] = "Quadro de durabilidade"

L["无2"] = "|cffFF0000Não|r"
L["无"] = "Não"
L["合剂"] = "Frasco"
L["食物"] = "Comida"
L["过远"] = "OoR"
L["距离过远"] = "Fora do campo de visão"
L["dbm_pull"] = "Puxar"
L["dbm_lag"] = "Checar lantência"
L["需要加载DBM"] = "DBM precisa estar ativado para essa opção."
L["无合剂增益"] = "Ninguem tem buff de frasco."
L["无食物增益"] = "Ninguem tem buff de comida."
L["全合剂增益"] = "Todos tem buff de comida."
L["全食物增益"] = "Todos tem buff de comida."
L["偷药水"] = "Não tinham buff de poção quando o combate começou: "
L["全偷药水"] = "Todos tinham buff de poção quando o combate começou."
L["药水"] = "Não usaram poção durante o combate: "
L["全药水"] = "Todos usaram poção durante o combate."

L["无法自动邀请进组:"] = "Eu não posso convidar você(s):"
L["我不能组人"] = "Eu não sou um lider ou assistente de raide"
L["小队满了"] = "grupo está cheio"
L["团队满了"] = "raide está cheio"
L["客户端错误"] = "Eu não posso convidar você por palavra-passe agora, sua conta parece aderir à %s."

L["的徽章冷却就绪"] = "'s BerloquePVP está pronto"
L["使用了徽章"] = " usou BerloquePVP"

L["界面移动工具"] = "Organizar quadros"
L["锚点框体"] = "Quadro ancorado"
L["重置位置"] = "Restaure esse quadro para seu estado padrão."
L["healer"] = "|cff76EE00Curador|r"
L["dpser"] = "|cffE066FFDps/Tanque|r"
L["选中的框体"] = "Quadro atual"
L["当前模式"] = "Modo atual"
L["进入战斗锁定"] = "Entrou em combate, quadros travados."

L["钱不够"] = "Você não tem dinheiro suficiente para comprar isso"
L["购买"] = "Comprado %d %s."
L["货物不足"] = "O mercador não tem o bastante"
L["光标"] = "Mouse"
L["当前"] = "Jogador"


L["上一条"] = "Anterior"
L["下一条"] = "Próximo"
L["我不想看到这些提示"] = "Eu não quero vê-los"
L["隐藏提示的提示"] = "Você pode reativar essas dicas em GUI → Outros"

L["TIPS"] = {
	"Altz UI pode esconder o minimapa e bate-papo quando você entrar e mostrar quando sair de combate. GUI → Outros",
	"Clique no relógio no minimapa para abrir o calendário; Clique-direito alterna entre horário local/servidor enquanto um clique-direito (pressionando alt, ctrl, ou shift) muda o formato do horário entre 12/24",
	"Quer ativar cores por classe nos seus quadros de raide? GUI → Quadros de unidade → Estilo → Tema clássico",
	"Quer mostrar barras de lançamento independentes? GUI → Quadros de unidade → Barra de lançamento → Marque 'Barra de lançamento indenpendente'",
	"Quer usar o estilo curandeiro nos quadros de raide? GUI → Quadros de raide → Alternância → Marque 'Desativar alternância automática'",
	"Quer alternar posições da barra de ações principal e adicional? GUI → Barra de ações → Principal → Marque 'Colocar principal acima da adicional'",
	"Quer usar uma cor personalizada para as placas de nomes de uma unidade especifica? GUI → Placas de identificação → Cor personalizada",
	"Quer mudar o tamanho do minimapa? GUI → Outros → Altura da alternância",
	"/rl - Reinicia UI",
	"/hb - Modo vinculação de teclas",
	"Use SHIFT+Clique para adicionar o alvo ao foco; está disponível para quadros de unidade.",
	"Use ALT+Clique para Triturar/Prospectar/Desencantar/Destravar automáticamente.",
	"Pressione Tab para alternar entre canais de bate-papo quando digitar alguma mensagem no bate-papo.",
	"Os arquivos de fonte estão localizados em 'Interface\\AddOns\\AuroraClassic\\media\\font.ttf(fonte principal),Interface\\AddOns\\AltzUI\\media\\number.ttf'(fonte para algum texto de tempo)",
	"Segure Ctrl, Alt ou Shift para rolar o bate-papo para a parte superior/inferior.",
	"Clicando na borda de algum botão ativara a função de auto-esconder, ex: Menu/Ferramentas de Raide/Configurações.",
 }

L["出现了！"] = " visto!"
