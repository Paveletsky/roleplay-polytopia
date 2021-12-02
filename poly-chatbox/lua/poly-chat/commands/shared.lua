hook.Add( 'Initialize', 'loadCommands', function()
    hook.Remove( 'Initialize', 'loadCommands' )
    
    --
    --  remove default drp commands
    --

    local whitelist = {
        ['job'] = true,
        ['buyammo'] = true,
    }

    for k, list in pairs( DarkRP.getChatCommands() ) do
        if list.author != 'poly' and !whitelist[list.command] then DarkRP.removeChatCommand( list.command ) end
    end

    -- for k, list in pairs( DarkRP.getChatCommands() ) do
    --     print( list.command )
    -- end

    --
    --  register custom commands
    --

    DarkRP.declareChatCommand{
        command = "me",
        author = 'poly',
        description = "Действие от первого лица, то, что вы выполняете на данный момент. \n\nНапример: \n\nХасан Агаджери вытаскивает из кармана пистолет, передает его Кургану и 'ехидно' улыбается.",
        delay = 1.5
    }

    DarkRP.declareChatCommand{
        command = "doit",
        author = 'poly',
        description = "Действие, которое происходит в окружении вас и людей поблизости. \n\nВыглядит это так: \n\nОкружение могло наблюдать, как Хасан переглядывался с копами и хотел вот-вот дать дёру. <Хасан Агаджери>",
        delay = 1.5
    }

    DarkRP.declareChatCommand{
        command = "yit",
        author = 'poly',
        description = "Описание окружения, которое окружающие могут наблюдать издалека от вас.",
        delay = 1.5
    }

    DarkRP.declareChatCommand{
        command = "wit",
        author = 'poly',
        description = "Описание окружения, которое могут наблюдать лишь те, кто находится с вами в маленьком помещении или стоя очень близко.",
        delay = 1.5
    }

    DarkRP.declareChatCommand{
        command = "yme",
        author = 'poly',
        description = "Действие от первого лица, которое могут наблюдать издалека.",
        delay = 1.5
    }

    DarkRP.declareChatCommand{
        command = "wme",
        author = 'poly',
        description = "Это действие от первого лица, которое отображается прямо на вашей модели, но не пишется в чат, надпись исчезает через 15 секунд. Используйте чтобы не засорять чат, или выполнять мелкие дейстия. Текст заменяется если прописать команду вновь.",
        delay = 1.5
    }

end)