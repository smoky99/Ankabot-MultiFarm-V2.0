# Yaya_Tools
 Ensemble de fonctions utiles pour AnkaBot
 
 1. Créer un dossier nommer YAYA a la racine d'Ankabot
 2. Déplacer tout les fichier dans le dossier YAYA

 Les ID des Zone et sous zone sont dans les fichier nommer areaId.txt et subAreaId.txt
 
 Si une update dofus modifie des carte ou ajoute des monstres :
 1. Télécharger Pydofus
 2. Récupérer les fichier Areas.d2o, Items.d2o, Monsters.d2o, SubAreas.d2o, Recipes.d2o dans Dofus\data\common
 3. Récupérer le fichier i18n_fr.d2i dans Dofus\data\i18n
 4. Convertisser les fichier en json grace a pydofus et placer les json dans YAYA\MajInfoJson
 5. Executer MonstersLootInfo.exe
 6. Un dossier YAYA a était créer avec les nouvelles valeurs
 
## Les fonction
 
## Zone
1. Pour utiliser les fonction Zone mettez cette ligne en haut de votre script lua :

   Zone = dofile(global:getCurrentDirectory() .. "\\\YAYA\\\Module\\\Zone.lua")

### Area

* Zone:GetAreaMapId(areaId) 
  * Retourne toutes les mapId d'une zone dans une table {}
  * Params 1 : ID de l'area
 
* Zone:GetAreaName(areaId)
  * Retourne le nom de la zone
  * Params 1 : ID de l'area

* Zone:GetSubArea(areaId)
  * Retourne touts les ID des sous zone dans une table {}
  * Params 1 : ID de l'area

### SubArea

* Zone:GetSubAreaMapId(subAreaId) 
  * Retourne toutes les mapId d'une sous zone dans une table {}
  * Params 1 : ID de la sous zone
 
* Zone:GetSubAreaName(subAreaId)
  * Retourne le nom de la sous zone
  * Params 1 : ID de la sous zone

* Zone:GetSubAreaMonsters(subAreaId)
  * Retourne touts les monstersId présent dans la sous zone dans une table {}
  * Params 1 : ID de la sous zone

* Zone:GetArea(subAreaId)
  * Retourne l'idArea de la sous zone
  * Params 1 : ID de la sous zone

## Movement

1. Pour utiliser les fonction Movement mettez cette ligne en haut de votre script lua :

   Movement = dofile(global:getCurrentDirectory() .. "\\\YAYA\\\Module\\\Movement.lua")
   
* Movement:RoadZone(tblMapId) 
  * Déplace le bot en fonction des mapId dans la table
  * Params 1 : Table de mapId

* Movement:InMapChecker(tblMapId) 
  * Retourne si le bot et présent sur une des mapId de la table
  * Params 1 : Table de mapId

## Monsters
1. Pour utiliser les fonction Monsters mettez cette ligne en haut de votre script lua :

   Monsters = dofile(global:getCurrentDirectory() .. "\\\YAYA\\\Module\\\Monsters.lua")

* Monsters:GetMonsterName(idMonster) 
  * Retourne le nom du monstre
  * Params 1 : ID du monstre

* Monsters:GetFavoriteSubArea(idMonster) 
  * Retourne l'ID favorite de la sous zone du monstre
  * Params 1 : ID du monstre

* Monsters:GetMonsterDrops(idMonster) 
  * Retourne tout les ID des items dropable sur le monstre dans une table {}
  * Params 1 : ID du monstre

* Monsters:GetMonsterSubArea(idMonster) 
  * Retourne tout les ID des sous zone ou le monstre et présent dans une table {}
  * Params 1 : ID du monstre
  * 
* Monsters:GetMonsterIdByDropId(dropId) 
  * Retourne tout les ID des monstres qui drop cette item dans une table {}
  * Params 1 : ID de l'item

## Craft
1. Pour utiliser les fonction Craft mettez cette ligne en haut de votre script lua :

   Craft = dofile(global:getCurrentDirectory() .. "\\\YAYA\\\Module\\\Craft.lua")

* Craft:GetCraftInfo(idCraft) 
  * Retourne une table contenant les info du craft (craft.jobId, craft.craftLvl, craft.typeId, craft.skillId, craft.ingredients{})
  * Params 1 : ID de l'item

* Craft:GetIngredients(idCraft) 
  * Retourne une table contenant les info des ingredients du craft (ingredient.ingredientId, ingredient.quantity)
  * Params 1 : ID de l'item

* Craft:GetJobId(idCraft) 
  * Retourne le jobId du craft
  * Params 1 : ID de l'item

* Craft:GetSkillId(idCraft) 
  * Retourne le skillId du craft
  * Params 1 : ID de l'item

* Craft:GetLevel(idCraft) 
  * Retourne le level du craft
  * Params 1 : ID de l'item

 * Craft:GetTypeId(idCraft) 
  * Retourne le typeId du craft
  * Params 1 : ID de l'item

## Utils
1. Pour utiliser les fonction Utils mettez cette ligne en haut de votre script lua :

   Utils = dofile(global:getCurrentDirectory() .. "\\\YAYA\\\Module\\\Utils.lua")
   
* Utils:Print(msg, header, msgType) 
  * Print un message dans la console Ankabot en fonction des paramètre
  * Params 1 : Message a print
  * Params 2 (facultatif) : Place un header avant le message ([header] message)
  * params 3 (facultatif) : "warn" ou "error" Colorie le message et place un header d'avertissement, le params 2 et obligatoire ([Avertissement][header] message)

* Utils:Dump(tbl)
  * Parcours tout les éléments d'une table et ses sous tables en affichant leurs valeurs
  * Params 1 : La table

* Utils:Equal(str1, str2)
  * Retourne true si les valeur sont égale, false si elle ne sont pas égale
  * Params 1 : Valeur a comparé (int, string)
  * Params 2 : Valeur a comparé (int, string)

* Utils:GetTableValue(index, tbl)
  * Retourne la valeur d'un élément d'une table a l'index indiqué
  * Params 1 : L'index souhaité
  * Params 2 : La table

* Utils:LenghtOfTable(tbl)
  * Retourne la taille de la table (utile quand #tbl bug)
  * Params 1 : La table 

* Utils:ShuffleTbl(tbl)
  * Mélange les élément d'une table et retourne la table mélangé
  * Params 1 : La table 

* Utils:ReadFile(path)
  * Retourne le contenu d'un fichier
  * Params 1 : Chemin du fichier
