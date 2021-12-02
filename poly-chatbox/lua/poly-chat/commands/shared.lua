hook.Add( 'Initialize', 'loadCommands', function()

    --
    --  remove default drp commands
    --

    DarkRP.removeChatCommand( 'me' )
    DarkRP.removeChatCommand( 'w' )
    DarkRP.removeChatCommand( 'y' )
    DarkRP.removeChatCommand( '//' )
    DarkRP.removeChatCommand( '/' )
    DarkRP.removeChatCommand( 'ooc' )
    DarkRP.removeChatCommand( 'a' )
    DarkRP.removeChatCommand( 'broadcast' )
    DarkRP.removeChatCommand( 'channel' )
    DarkRP.removeChatCommand( 'radio' )
    DarkRP.removeChatCommand( 'group' )
    DarkRP.removeChatCommand( 'credits' )
    

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