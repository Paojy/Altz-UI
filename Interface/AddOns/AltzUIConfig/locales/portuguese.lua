local T, C, L, G = unpack(select(2, ...))
if G.Client ~= "ptBR" then return end -- AltzUIConfig - Portuguese Language

-- 安装
L["小泡泡"] = "Paopao"
L["欢迎使用"] = "Bem-vindo às configurações do AltzUI"
L["简介"] = "AltzUI é uma compilação minimalista com suporte à configuração em jogo. Eu queria fazer uma UI que desse as pessoas o sentimento de esconder quase todos os elementos da interface, como pressionar 'Alt-Z', e foi dai que veio o nome da compilação. O primeiro 'release' foi em 11 de Novembro de 2011. O tema de AltzUI é simplicidade. Isso mostra apenas os elementos necessários quando você desejar vê-los. O uso de memória e CPU é bem baixo, com apenas 2 ~ 3mb é capaz de completar todas as funcionabilidade que você precisa. Porfavor recomende essa UI aos que não a conhecem. Obrigado!"

--L["上一步"] = "Previous"
--L["下一步"] = "Next"
--L["跳过"] = "Skip Setup Wizard"
--L["打开设置向导"] = "/Setup Open Setup Wizard"
--L["完成"] = "Finish"
--L["更新日志"] = "Update Log"
--L["更新日志tip"] = "New setup wizard.\nFix various errors."
--L["寻求帮助"] = "Help"
--L["粘贴"] = "Press Ctrl + c to copy the link"

-- 控制台通用
--L["界面"] = "Interface"
L["启用"] = "Ativar"
L["控制台"] = "GUI"
L["图标大小"] = "Tamanho do ícone: "
L["图标数量"] = "Numero de auras: "
L["图标间距"] = "Espaço entre ícones: "
L["缩放尺寸"] = "Escala: "
L["字体大小"] = "Tamanho da fonte: "
L["尺寸"] = "Tamanho"
L["高度"] = "Altura: "
L["宽度"] = "Largura: "
L["光环"] = "Auras"
--L["图标"] = "Icon"
L["Buffs"] = "Buffs"
L["Debuffs"] = "Debuffs"
L["每一行的图标数量"] = "Número de ícones por linha: "
L["输入法术ID"] = "Insira um 'spellID'"
L["左"] = "Esquerda"
L["右"] = "Direita"
L["上"] = "Cima"
L["下"] = "Baixo"
L["左上"] = "Superior Esquerdo"
L["右上"] = "Superior Direito"
L["上方"] = "Superior"
L["下方"] = "Inferior"
L["垂直"] = "Vertical"
L["水平"] = "Horizontal"
L["正向"] = "Crescente"
L["反向"] = "Decrescente"
L["显示冷却"] = "Mostrar recarga de %s."
L["导入/导出配置"] = "Importar configurações"
L["排列方向"] = "Âncora"

-- 介绍
L["介绍"] = "Introdução"
L["重置确认"] = "Você deseja restaurar todas as configurações de %s?"
L["重置"] = "Restaurar"
L["导入确认"] = "Você deseja importar todas as configurações de %s?\n"
L["版本不符合"] = "\nImportar versões %s（Current Version %s）"
L["客户端不符合"] = "\nCliente do jogo %s（Current Client %s）"
L["职业不符合"] = "\nClasse %s（Current Class %s）"
L["不完整导入"] = "\nTalvez não importe completamente."
L["导入"] = "Importar"
L["导出"] = "Exportar"
L["无法导入"] = "Impossível importar"

-- 聊天
--L["聊天按钮悬停渐隐"] = "Social Buttons Hover Fading"
--L["聊天按钮悬停渐隐提示"] = "Enble button fading when your mouse is not hovering over them."
L["频道缩写"] = "Substituir nome do canal"
L["滚动聊天框"] = "Rolar pelo bate-papo"
L["滚动聊天框提示"] = "Auto rolar para a última mensagem do bate-papo depois de alguns segundos."
L["自动邀请"] = "Palavra-passe de convite"
L["自动邀请提示"] = "Auto convidar pessoas sussurando a palavra-passe"
L["关键词"] = "Palavra-passe"
L["关键词输入"] = "Insira palavras separadas por um espaço"
L["聊天过滤"] = "Filtro de bate-papo"
--L["聊天过滤提示"] = "Hide repeated chat messages and chat messages containing key word(s) below."
L["过滤阈值"] = "Número de palavra(s)-passe: "
L["显示聊天框背景"] = "Mostrar fundo do bate-papo."

-- 背包和物品
L["启用背包模块"] = "Ativar módulo de inventário"
L["背包图标大小"] = "Tamanho do ícone do inventário: "
L["背包每行图标数量"] = "N° de ícones do inventário por linha: "
L["自动修理"] = "Auto reparar"
L["自动修理提示"] = "Repara automáticamente os itens."
L["自动公会修理"] = "Auto reparar pela guida"
L["自动公会修理提示"] = "Repara automáticamente os itens usando dinheiro da guilda."
--L["灵活公会修理"] = "Flexible Guild Repair"
--L["灵活公会修理提示"] = "Use your own money when go over guild repair limit."
L["自动售卖"] = "Auto vender"
L["自动售卖提示"] = "Vende automáticamente os itens 'sucata'."
L["已会配方着色"] = "Colorizes Known Items"
L["已会配方着色提示"] = "Colorizes the item that is already known in some default frames."
L["自动购买"] = "Auto comprar"
L["自动购买提示"] = "Automáticamente compra itens da lista abaixo."
--L["输入自动购买的物品ID"] = "Input Auto-buy-item ID"
L["输入物品ID"] = "Insira o 'Item ID'"
L["输入数量"] = "quantidade"
L["不正确的物品ID"] = "'Item ID' incorreto!"
L["不正确的数量"] = "Quantidade incorreta!"
L["显示物品等级"] = "Mostrar nível de item"
L["显示物品等级提示"] = "Mostra o nível de item da arma/armadura no seu quadro de personagem e inventário."
L["便捷物品按钮"] = "Botões de itens conveniêntes"
L["便捷物品按钮提示"] = "Os botões apenas ficam visíveis quando você não está em combate."
L["每行图标数量"] = "número de ícones por linha"
L["精确匹配"] = "Item Exato"
L["精确匹配提示"] = "Ative para mostrar item exato, caso contrário também mostra itens com feitiço similar. (e.g. itens de poder de artefato)"
L["显示数量"] = "Mostrar Contagem"
L["显示数量提示"] = "Mostrar contagem de item no inventário."
L["条件"] = "Condições"
L["总是显示"] = "Sempre"
L["在职业大厅显示"] = "No Salão de Classe"
L["在团队副本中显示"] = "Em Raide"
L["在地下城中显示"] = "Em Masmorra"
L["在战场中显示"] = "Em CB"

-- 单位框体
L["单位框体"] = "Quadros de unidade"
L["样式"] =  "Estilo"
L["总是显示生命值"] = "Sempre mostrar o HP(vida)"
L["总是显示生命值提示"] = "Desative para mostrar os pontos de vida apenas quando não estiver cheio."
L["总是显示能量值"] = "Sempre mostrar o PP(mana)"
L["总是显示能量值提示"] = "Desative para mostrar os pontos de mana apenas quando não estiver cheio."
L["数值字号"] = "Tamanho da fonte: "
L["数值字号提示"] = "Tamanho da fonte para o HP e PP."
L["显示肖像"] = "Mostrar retrato do personagem"
L["肖像透明度"] = "Opacidade do retrato: "
L["宽度提示"] = "A largura do quadro do jogador, alvo e foco."
L["宠物框体宽度"] = "Largura do quadro do ajudante: "
L["首领框体和PVP框体的宽度"] = "Largura do quadro do chefe/arena: "
L["生命条高度比"] = "Altura da barra de vida: "
L["生命条高度比提示"] = "Altura da barra de vida em relação ao quadro do jogador."
L["施法条"] = "Barra de lançamento"
L["独立施法条"] = "Barra de lançamento indenpendente"
L["玩家施法条"] = "Jogador "
L["目标施法条"] = "Alvo "
L["焦点施法条"] = "Foco "
L["法术名称位置"] = "Posição do nome da magia"
--L["可打断施法条图标颜色"] = "Interruptible spell icon border color"
--L["不可打断施法条图标颜色"] = "Not interruptible spell icon border color"
L["施法时间位置"] = "Posição da duração do lançamento"
L["引导法术分段"] = "Mostrar todos os 'ticks' em uma magia canalizada"
--L["隐藏玩家施法条图标"] = "Hide the icon on player castbar"
L["平砍计时条"] = "Tempo de balanço"
L["显示副手"] = "Mostrar barra da mão-secundária"
L["显示平砍计时"] = "Mostrar tempo em texto"
L["减益边框"] = "Borda dos 'debuffs'"
L["减益边框提示"] = "Cor da borda dos 'debuffs' baseado no tipo."
L["每行的光环数量提示"] = "Tamanho do ícone das auras."
L["玩家减益"] = "'Debuffs' do jogador"
L["玩家减益提示"] = "Mostra os próprios 'debuffs' acima do quadro do jogador."
L["过滤增益"] = "Filtro de aura: Ignorar 'Buffs'"
L["过滤增益提示"] = "Esconde 'buffs' de outros em aliados."
L["过滤减益"] = "Filtro de aura: Ignorar 'Debuffs'"
L["过滤减益提示"] = "Esconde 'debuffs' de outros em inimigos."
--L["过滤小队增益"] = "Filter Party HOTs"
--L["过滤小队增益提示"] = "Fliter Hots of mine on party frame by rules of Icon-style Indicators of raid frames"
L["白名单"] = "Lista Branca"
L["白名单提示"] = "Edita lista branca para forçar uma aura a aparecer quando ativar o filtro.\nSe um debuff castado por outros em um inimigo esta na lista branca, sua cor não vai sumir."
L["已经在白名单中"] = "já está na lista branca."
L["被添加到法术过滤白名单中"] = "foi adicionado à lista branca."
L["从法术过滤白名单中移出"] = "foi removido da lista branca."
L["不是一个有效的法术ID"] = "não é um 'spell ID' válido."
L["图腾条"] = "Barra de totem"
L["显示PvP标记"] = "Mostrar ícone JvJ"
L["显示PvP标记提示"] = "Recomendado em um servidor 'JvA'."
L["启用首领框体"] = "Ativar quadros de chefes"
L["启用PVP框体"] = "Ativar quadros de arenas"
--L["在小队中显示自己"] = "Show player in party frames"
--L["显示小队宠物"] = "Show party pets"
L["显示法力条"] = "Mostrar barra de mana"
L["显示法力条提示"] = "Mostra barra de mana para xamã aperfeiçoamento e elemental."
L["启用仇恨条"] = "Mostrar barra de ameaça"
L["显示醉拳条"] = "Mostrar barra de atordoamento"

-- 团队框架
L["团队框架"] = "Quadros de raide"
--L["团队框架tip"] = "Does the Raid Frames change with specialization?"
L["通用设置"] = "Geral"
L["显示宠物"] = "Mostrar ajudantes"
L["名字长度"] = "Tamanho do nome: "
L["未进组时显示"] = "Mostrar quando estiver 'solo'"
--L["刷新载具"] = "Toggle for vehicle"
L["切换"] = "Alternância"
L["禁用自动切换"] = "Desativar alternância automática"
L["禁用自动切换提示"] = "Desative para alternar o quadro de raide automáticamente quando trocar sua atual 'Spec'."
L["团队模式"] = "Modo raide"
L["治疗模式"] = "Curandeiro"
L["输出/坦克模式"] = "Dps/Tanque"
L["团队规模"] = "Tamanho do grupo"
L["40-man"] = "40-pers"
L["30-man"] = "30-pers"
L["20-man"] = "20-pers"
L["10-man"] = "10-pers"
L["raidmanabars"] = "Mostrar barra de mana"
L["GCD"] = "Barra de 'GCD'"
L["GCD提示"] = "Mostra barra de 'GCD' nos quadros de raide."
L["显示缺失生命值"] = "Mostrar HP"
L["显示缺失生命值提示"] = "Mostra pontos de vida faltantes quando o HP estiver abaixo de 90%."
L["治疗和吸收预估"] = "Efeito de futura cura ou absorção"
L["治疗和吸收预估提示"] = "Mostra futura cura ou abosorção por cima da barra de vida."
L["职业顺序"] = "Organizar quadros de raide pela classe."
L["整体高度"] = "Quadros por linha"
L["整体高度提示"] = "Quantas unidades você quer mostrar por linha?"
L["点击施法"] = "Magia-Instantânea"
L["点击施法提示"] = "Insira %starget|r para o alvo que o mouse está sobre.\nInsira %stot|r para o alvo do alvo que o mouse está sobre.\nInsura %sfocus|r para o foco do alvo que o mouse está sobre.\nInsira %sfollow|r para seguir o alvo que o mouse está sobre.\nInsira %sa feitiço|r para lançar no alvo que o mouse está sobre.\nInsira %smacro|r vincular a tecla para o botão"
L["Button1"] = "Esquerda"
L["Button2"] = "Direita"
L["Button3"] = "Meio"
L["Button4"] = "4"
L["Button5"] = "5"
L["MouseUp"] = "MouseUp"
L["MouseDown"] = "MouseDown"
L["不正确的法术名称"] = "Feitiço incorreto"
L["输入一个宏"] = "Coloque um macro"
L["团队减益"] = "'Debuffs' de raide"
L["输入层级"] = "Nível"
L["必须是一个数字"] = "precisa ser um número."
L["重要法术"] = "Recarga de aura"
L["主坦克和主助手"] = "Ícone de tanque e assistente principal"
L["主坦克和主助手提示"] = "Mostra ícone de tanque e assistente principal do raide."
L["治疗指示器"] = "Indicadores de curandeiro"
L["数字指示器"] = "Indicador estilo: número"
L["图标指示器"] = "Indicador estilo: ícone"

-- 动作条
--L["向上排列"] = "Grow Bar Upwards"
--L["向上排列说明"] = "This growns the bars upwards when in a horizontal layout"
L["显示冷却时间"] = "Mostrar texto de recarga"
L["冷却时间数字大小"] = "Tamanho do texto de recarga: "
L["冷却时间数字大小提示"] = "This value only affect cooldown frames which size is bigger than 25*25pixel,\n others have their appropriate sized text.\nNote that the cooldown text won't show if it's too small." --
L["显示冷却时间提示"] = "Mostrar texto de recarga nos botões da barra de ações, itens do inventário, etc."
--L["显示冷却时间提示WA"] = "Displaying cooldown text on Weakauras displays"
L["不可用颜色"] = "Descolorizar botões quando inutilizado"
L["不可用颜色提示"] = "Descoloriza o botão da barra de ações quando eles ficam inutilizados.\nComo: fora de alcance, sem mana, etc."
L["键位字体大小"] = "Tamanho do texto das teclas de atalho: "
L["宏名字字体大小"] = "Tamanho do texto do nome do macro: "
L["可用次数字体大小"] = "Tamanho do texto de contagem: "

L["条件渐隐"] = "Esvanecimento condicional"
--L["条件渐隐提示"] = "Enable Fading when you are not casting, not in combat,\ndon't have a target and got max health or max/min power, etc."
L["悬停渐隐"] = "Desativar esvanecimento quando mouse passar sobre"
L["悬停渐隐提示"] = "Desativar esvanecimento da barra de ações quando o mouse passar sobre."
L["渐隐透明度"] = "Opacidade do esvanecimento: "
L["渐隐透明度提示"] = "Opacidade minima do esvanecimento."
--L["标签最大透明度"] = "Chat tab max alpha"
--L["标签最大透明度提示"] = "Chat tab alpha while mouse is hovering over them."
--L["标签最小透明度"] = "Chat tab min alpha"
--L["标签最小透明度提示"] = "Chat tab alpha while mouse is NOT hovering over them."

L["主动作条"] = "Principal"
L["额外动作条"] = "Adicional"
L["额外动作条布局"] = "Estilo da barra de ações adicionais"
L["布局1"] = "12*1"
L["布局232"] = "2*3*2"
L["布局322"] = "3*2*2"
L["布局43"] = "4*3"
L["布局62"] = "6*2"
L["额外动作条间距"] = "Espaçamento"
L["额外动作条间距提示"] = "O espaço entre a parte esquerda a direita da barra de ações principal(bar12's width + 2*space1).\nDisponivel apenas quando o estilo 3*2*2 estiver ativo."
L["6*4布局"] = "Estilo 6*4"
L["右侧额外动作条"] = "Adicional direita"
L["宠物动作条"] = "Ajudante"
L["5*2布局"] = "Estilo 5*2"
L["5*2布局提示"] = "Usar estilo 5*2 para barra de ações do ajudante, desative para user o estilo 10*1."
L["姿态/形态条"] = "Barra de postura"
L["离开载具按钮"] = "Botão de sair do veículo"
L["额外特殊按钮"] = "Tamanho do botão extra: "
L["横向动作条"] = "Barra de ações adicional direita horizontal"

L["冷却提示"] = "Alerta de recarga"
L["透明度"] = "Opacidade: "
L["忽略法术"] = "Ignorar feitiços"
L["忽略物品"] = "Ignorar itens"

-- 增益和减益
L["行距"] = "Espaços na linha: "
L["图标左右间隙"] = "Espaço entre os ícones: "
L["持续时间大小"] = "Tamanho da fonte da duração: "
L["堆叠数字大小"] = "Tamanho da fonte de contagem: "
L["分离Buff和Debuff"] = "Separar 'Buffs' de 'Debuffs'"

-- 姓名板
--L["姓名板tip"] = "How do you want to display the nameplates?"
L["数字样式"] = "Estilo númerico"
--L["职业色-条形"] = "Class Color Bar"
--L["深色-条形"] = "Dark Color Bar"
L["仇恨染色"] = "Melhoria da cor de ameaça nas placas de nomes"
L["自定义颜色"] = "Cor personalizada"
L["空"] = "Vazio"
L["我的法术"] = "Minhas auras"
L["其他法术"] = "Outras auras"
L["黑名单"] = "Lista negra"
L["全部隐藏"] = "Esconder todos"
L["过滤方式"] = "Tipo de filtro"
L["显示玩家姓名板"] = "Mostrar placa de nome pessoal"
L["显示玩家姓名板光环"] = "Mostrar ícones de auras na próprio placa de nome"
--L["显示玩家施法条"] = "Show Castbar on My Nameplate"
L["姓名板资源位置"] = "Posição dos recursos"
--L["姓名板资源尺寸"] = "Player Resource Width"
L["目标姓名板"] = "Placa de nome do alvo"
L["玩家姓名板"] = "Placa de nome pessoal"
L["名字字体大小"] = "Tamanho da fonte do nome"
--L["可打断施法条颜色"] = "Interruptible castbar color"
--L["不可打断施法条颜色"] = "Not interruptible castbar color"
--L["自定义能量"] = "Custom Power"
--L["数值样式"] = "Value form"
--L["百分比"] = "Perc"
--L["数值和百分比"] = "Value+Perc"
--L["条形样式"] = "Bar"
--L["友方只显示名字"] = "Name-only on friendly units"
--L["根据血量染色"] = "Color according to hp perc"
--L["焦点染色"] = "Color focus target"
--L["焦点颜色"] = "Focus color"

-- 鼠标提示
L["跟随光标"] = "Mostrar no mouse"
L["隐藏服务器名称"] = "Esconder reino"
L["隐藏称号"] = "Esconder título"
L["显示法术编号"] = "Mostrar 'SpellID'"
L["显示物品编号"] = "Mostrar 'ItemID'"
L["显示天赋"] = "Mostrar 'Spec'"
L["战斗中隐藏"] = "Esconder em combate"
--L["背景透明度"] = "Backdrop Opacity"

-- 战斗信息
L["战斗信息"] = "Texto de combate"
L["承受伤害/治疗"] = "Texto de cura/dano recebido"
L["输出伤害/治疗"] = "Texto de cura/dano causado"
L["数字缩写样式"] = "Estilo de abreviação"
L["暴击图标大小"] = "Tamanho do ícone de crítico: "
L["显示DOT"] = "Mostrar dano ao longo do tempo"
L["显示HOT"] = "Mostrar cura ao longo do tempo"
L["显示宠物"] = "Mostrar dano do ajudante"
L["隐藏时间"] = "Tempo para esvanecer: "
L["隐藏时间提示"] =  "Tempo em segundos no qual o texto de combate fica visível antes de começar a esvanecer."
L["隐藏浮动战斗信息接受"] = "Esconder texto de combate da BLIZZARD (Texto de cura/dano causado)"
L["隐藏浮动战斗信息输出"] = "Esconder texto de combate da BLIZZARD (Texto de cura/dano recebido)"

-- 其他
L["界面风格"] = "Esquema de cor"
--L["界面风格tip"] = "How do you want to display the UnitFrames?"
L["透明样式"] = "Tema transparente"
L["深色样式"] = "Tema escuro"
L["普通样式"] = "Tema clássico"
--L["小地图尺寸"] = "Minimap Size"
L["系统菜单尺寸"] = "Escala do micromenu: "
--L["信息条"] = "Info Bar"
L["信息条尺寸"] = "Escala da barra informações: "
L["整理小地图图标"] = "Coletar botões do minimapa"
L["整理栏位置"] = "Posição de caixa final"
L["成就截图"] = "'Print' de conquistas"
L["成就截图提示"] = "Tirar um 'print' quando você conclui uma conquista."
L["自动接受复活"] = "Aceitar ressurreições"
L["自动接受复活提示"] = "Aceita ressurreições automáticamente, disponivel apenas quando fora do combate."
L["战场自动释放灵魂"] = "Auto liberar espírito em CBs"
L["战场自动释放灵魂提示"] = "Libera automáticamente o espírito em CBs."
L["隐藏错误提示"] = "Esconder erros"
L["隐藏错误提示提示"] = "Esconde o texto de erro, como: fora de alcance, etc."
L["自动接受邀请"] = "Aceitar convites"
L["自动接受邀请提示"] = "Aceita automáticamente convites de amigos ou membros da guilda."
L["自动交接任务"] = "Auto missões"
L["自动交接任务提示"] = "Automáticamente aceita/completa missões. Segure shift quando necessario para temporariamente desativar essa função."
L["大喊被闷了"] = "Dizer 'Sapped'"
L["大喊被闷了提示"] = "Diz 'Sapped!' para alertar aliados quando um ladino atordoar você."
L["显示插件使用小提示"] = "Mostrar dicas quando LDT"
L["显示插件使用小提示提示"] = "Mostra dicas do addon na tela quando estiver LDT"
L["稀有警报"] = "Alerta de pontos"
L["稀有警报提示"] = "Display the vignette-ids introduces with 5.0.4 (chests, rare mobs etc) with name and icon on screen."--
--L["在飞行中隐藏稀有提示"] = "Hide Vingette Alert when on taxi"
--L["在飞行中隐藏稀有提示说明"] = "Will not display vingette alerts if you are currently on a taxi"
L["任务栏闪动"] = "Piscar barra de tarefas"
L["任务栏闪动提示"] = "Pisca barra de tarefas quando você der 'alt-tab' e o WOW estiver em alguma fila."
L["自动召宝宝"] = "Auto sumonar ajudante"
L["自动召宝宝提示"] = "Automáticamente sumona um ajudante quando você logar, ressucitar ou sair do veículo."
L["随机奖励"] = "Alerta de LdG encurtado"
L["随机奖励提示"] = "Alert you when LFG RoleShortage Rewards occurs with Raid Warning, only available when solo."--
L["在战斗中隐藏小地图"] = "Esconder minimapa em combate"
L["在战斗中隐藏聊天框"] = "Esconder bate-papo em combate"
L["在副本中收起任务追踪"] = "Esconder rastreamento em instâncias"
L["在副本中收起任务追踪提示"] = "Esconde rastreamento de objetivos quando entrar em instâncias/campos de batalha, expande automáticamente quando você sair."
L["提升截图画质"] = "Melhoria de qualidade do 'print'"
L["截图保存为tga格式"] = "'Print' salvo com formato TGA"
--L["登陆屏幕"] = "Hide Interface on Login"
L["暂离屏幕"] = "Esconder interface quando LDT"
L["快速焦点"] = "Usar SHIFT + Clique para focar alvo."
--L["自定义任务追踪"] = "Custom Objective Tracker"
--L["自定义任务追踪提示"] = "Enable this if you are using a custom objective tracker addon.\n  (ex: Dugi Questing Essential, Kaliel's Tracker)"
--L["快速标记"] = "Use Ctrl+Click to add raid mark."

-- 插件皮肤
--L["界面布局"] = "Layout"
--L["界面布局tip"] = "How do you want to layout the Interface?"
--L["默认布局"] = "Default Layout"
--L["极简布局"] = "Minimal Layout"
--L["聚合布局"] = "Centralized layout"
L["插件皮肤"] = "'Skins' p/ AddOns"
L["更改设置"] = "Restaurar 'Skin' do AddOn"
L["更改设置提示"] = "Restaura configurações padrões para esse AddOn"
--L["边缘装饰"] = "Strip Decoration"
--L["两侧装饰"] = "Decoration on both sides"
--L["战斗字体"] = "Combat Text"

-- 命令
L["命令"] = "Comandos"
--L["指令"] = " %s/rl|r - Reload UI \n \n %s/hb|r - Key Binding Mode \n \n %sALT+Click|r - Mill/Prospect/Disenchant/Unlock instantly \n \n %sTab|r - Change between available channels. \n \n %s/Setup|r-Run the setup wizard"

-- 制作
L["制作"] = "Creditos"
L["制作说明"] = "AltzUI ver. %s \n \n \n \n Paopao zhCN \n \n \n \n %s Obrigado a \n \n %s \n e todos que me ajudaram com essa compilação.|r"