Config = dofile(global:getCurrentScriptDirectory() .. "\\Multi_Config.lua")
Utils = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Utils.lua")

Controller = {}

Controller.serverCreated = false
Controller.isTeamLoaded = false
Controller.isTeamConnected = false
Controller.isScriptLoaded = false
Controller.isStarted = false

Controller.loadedAccount = {}
Controller.loadedAccount.leader = {}
Controller.loadedAccount.group = {}
Controller.controllerServerName = "Controller"

function Controller:ControllerManager()

    if not self.serverCreated then
        self:CreateServer()
        self.serverCreated = true
    end

    if not self.isTeamLoaded then -- Chargement de la team
        Utils:Print("Chargement des comptes.....", "Controller")
        if ankabotController:accountIsLoaded(Config.controller.leaderAccountUsername) then -- Si le compte et déjâ charger on le decharge
            ankabotController:unloadAccountByUsername(Config.controller.leaderAccountUsername)
        end

        for _, v in pairs(Config.controller.groupAccountUsername) do
            if ankabotController:accountIsLoaded(v) then
                ankabotController:unloadAccountByUsername(v)
            end
        end

        self.loadedAccount.leader = ankabotController:loadAccount(Config.controller.leaderAccountUsername, false)

        if self.loadedAccount.leader == nil then
            Utils:Print("Erreur avec le nom de compte du leader [" .. Config.controller.leaderAccountUsername .. "] impossible de charger le compte vérifier son orthographe", "Controller")
            global:finishScript()
        end

        for _, v in pairs(Config.controller.groupAccountUsername) do
            local ctrlr = ankabotController:loadAccount(v, false)

            if ctrlr ~= nil then
                table.insert(self.loadedAccount.group, ctrlr)
            else
                Utils:Print("Erreur avec le nom de compte [" .. v .. "] impossible de charger le compte vérifier son orthographe", "Controller")
                global:finishScript()
            end
        end

        Utils:Print("Les comptes on été charger avec succès", "Controller")
        self.isTeamLoaded = true
    end

    if self.isTeamLoaded then -- Connexion de la team
        if not self.isTeamConnected then
            Utils:Print("Connexion des comptes", "Controller")

            self.loadedAccount.leader.forceServer(Config.controller.serverToConnect)
            self.loadedAccount.leader.forceChoose(Config.controller.leaderInGameUsername)
            self.loadedAccount.leader.connect()

            for i = 1, Utils:LenghtOfTable(self.loadedAccount.group) do
                self.loadedAccount.group[i].forceServer(Config.controller.serverToConnect)
                self.loadedAccount.group[i].forceChoose(Config.controller.groupInGameUsername[i])
                self.loadedAccount.group[i].connect()
            end

            while not self.loadedAccount.leader.isAccountFullyConnected() do
                global:delay(1000)
            end

            for _, v in pairs(self.loadedAccount.group) do
                while not v.isAccountFullyConnected() do
                    global:delay(1000)
                end
            end

            Utils:Print("Tout les comptes ont été connecté avec succès", "Controller")
            self.isTeamConnected = true
        end
    end

    if self.isTeamConnected then -- Chargement du script
        if not self.isScriptLoaded then
            local path = global:getCurrentScriptDirectory() .. "\\Multi_v2.0.lua"
            Utils:Print("Chargement du script....", "Controller")

            self.loadedAccount.leader.loadScript(path)

            for _, v in pairs(self.loadedAccount.group) do
                v.loadScript(path)
            end

            Utils:Print("Le script a été charger avec succès", "Controller")
            self.isScriptLoaded = true
        end
    end

    if self.isScriptLoaded and not self.isStarted then -- Configuration du script
        Utils:Print("Configuration du script", "Controller")
        local tmpCtrlr

        for _, v in pairs(self.loadedAccount.group) do
            tmpCtrlr = v.getScriptVariable("Controller")
            tmpCtrlr.isControlled = true
            tmpCtrlr.controllerServerName = self.controllerServerName
            v.setScriptVariable("Controller", tmpCtrlr)
        end

        tmpCtrlr = self.loadedAccount.leader.getScriptVariable("Controller")
        tmpCtrlr.isControlled = true
        tmpCtrlr.controllerServerName = self.controllerServerName
        self.loadedAccount.leader.setScriptVariable("Controller", tmpCtrlr)

        Utils:Print("Configuration terminée !", "Controller")
    end

    if not self.isStarted then -- Lancement du script
        Utils:Print("Lancement du script", "Controller")
        for _, v in pairs(self.loadedAccount.group) do
            v.startScript()
        end

        Utils:Print("Le script et lancée !", "Controller")

        self.loadedAccount.leader.startScript()
        self.isStarted = true
        global:finishScript()
    end


    global:delay(1000) -- Delai de vérif infoScript
end

function Controller:CreateServer()
    Utils:Print("Vérification du serveur", "serveur")

    if developer:getRequest("http://localhost:8080/isStarted") ~= "sucess" then
        Utils:Print("Le serveur n'est pas exécuter, exécution du serveur", "serveur")
        os.execute("start node " .. global:getCurrentScriptDirectory() .. "\\ControllerServer\\app.js %ComSpec% /D /E:ON /K")
        while developer:getRequest("http://localhost:8080/isStarted") ~= "sucess" do
            global:delay(1000)
        end
        Utils:Print("Le serveur a été lancée", "serveur")
    else
        Utils:Print("Le serveur et déja exécuter", "serveur")
    end

    Utils:Print("Création d'un nouveau controller dans le serveur", "serveur")
    local iController = 1
    local status = ""

    while status ~= "sucess" do
        status = developer:postRequest("http://localhost:8080/newController", "controllerName=" .. self.controllerServerName .. iController)
        if status ~= "sucess" then
            iController = iController + 1
        end
    end

    self.controllerServerName = self.controllerServerName .. iController

    Utils:Print("Nouveau controller [" .. self.controllerServerName .. "] créer dans le serveur", "serveur")
end

function move()
    while true do
        Controller:ControllerManager()
    end
end