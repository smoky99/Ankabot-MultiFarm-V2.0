require('babel-register')
const express = require('express')
const app = express()
const morgan = require('morgan')
const bodyParser = require('body-parser')


let controller = {}

app.use(morgan('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended : false }))


app.get('/isStarted', (req, res) => {
    res.status(200).send('sucess')
})

app.get('/getController/:controllerName', (req, res) => {
    if (Object.prototype.hasOwnProperty.call(controller, req.params.controllerName)) {
        res.status(200).send(JSON.stringify(controller[req.params.controllerName]))  
    }
    else {
        console.log('Le personnage [' + req.body.username + '] existe déjà dans le controller [' + req.body.controllerName + ']')
        res.status(404).send("Controller doesn't exist")
    }
})

app.post('/newController', (req, res) => {
    if (!Object.prototype.hasOwnProperty.call(controller, req.body.controllerName)) {
        console.log('Nouveau controller [' + req.body.controllerName + '] créer dans le serveur')
        controller[req.body.controllerName] = {
            leaderHasAnUpdate : false,
            leaderNewInfo : {},
            groupHasAnUpdate : false,
            groupNewInfo : {},
            character : {}
        }
        res.status(200).send('sucess')
    }
    else {
        console.log('Le controller [' + req.body.controllerName + '] existe déjà')
        res.status(422).send('already exist')
    }
})

app.post('/updateController', (req, res) => {
    if (Object.prototype.hasOwnProperty.call(controller, req.body.controllerName)) {
        console.log('Update du controller [' + req.body.controllerName + ']')

        controller[req.body.controllerName] = JSON.parse(req.body.updateController)
        res.status(200).send('sucess')
    }
    else {
        console.log('Le personnage [' + req.body.username + '] existe déjà dans le controller [' + req.body.controllerName + ']')
        res.status(404).send("Controller doesn't exist")
    }

})

app.post('/addCharacter/', (req, res) => {
    if (Object.prototype.hasOwnProperty.call(controller, req.body.controllerName)) {
        if (!Object.prototype.hasOwnProperty.call(controller[req.body.controllerName].character, req.body.username)) {
            console.log('Ajout du personnage [' + req.body.username + '] dans le controller [' + req.body.controllerName + ']')
            controller[req.body.controllerName].character[req.body.username] = req.body.username
            res.status(200).send('sucess')
        }
        else {
            console.log('Le personnage [' + req.body.username + '] existe déjà dans le controller [' + req.body.controllerName + ']')
            res.status(422).send('already exist')

        }
    }
    else {
        console.log('Le personnage [' + req.body.username + '] existe déjà dans le controller [' + req.body.controllerName + ']')
        res.status(404).send("Controller doesn't exist")
    }

})


app.listen(8080, () => {
    console.log('Le serveur a démarer sur le port 8080')
})