#juego de la vida
class Cell
    attr_accessor :status

    def initialize
        #Metodo para inicializar la celula
        @status = "Dead"
    end

    def setDead
        #Metodo para cambiar la celula a muerta
        @status = 'Dead'
    end

    def setAlive
        #Metodo para cambiar la celula a viva
        @status = 'Alive'
    end

    def isAlive
        #Metodo para checar si la celula esta viva
        #Retorna true si lo esta y falso si no
        if @status == 'Alive'
            true
        else 
            false
        end
    end

    def getPrintCharacter
    #metodo para imprimir en el tablero 
        if self.isAlive 
            "O"
        else 
            "*"
        end
    end
end


class Board
    
    attr_accessor :grid

    def initialize
        #Incializamos los atributos que se usaran en la clase board 
        #Ademas de ejecutrar los metodos en la secuencia necesaria
        @rows = 0
        @columns = 0  
        self.getBoardSize
        @grid = Array.new(@rows){ Array.new(@columns) { Cell.new } }
        self.generateBoard
        print "Iniciando el talbero\n"
        
    end         

    def generateBoard
        #Metodo para generar la primera generación del
        @rows.times do |i|
            @columns.times do |j|
                randomChance = rand(2) #25%
                if randomChance == 1
                    @grid[i][j].setAlive
                end
            end
        end
    end

    def drawBoard
        #Metodo para dibujar el tablero en la terminal
        print "\n"
        
        @rows.times do |i|
            @columns.times do |j|
                print "#{@grid[i][j].getPrintCharacter} "
             end
            print "\n"
        end
    end

    def updateBoard
        print "\nActualizando el tablero\n"
        #Lista de celulas vivas que se van a matar o resucitar o se mantienen vivas
        aliveCells = []
        deadCells = []

        @rows.times do |i|
            @columns.times do |j|
                #Checamos la celula actual y su estado
                cellObject = @grid[i][j]
                statusMainCell = cellObject.isAlive
                
                #Checamos los vecinos de la celula actual y su estado
                checkNeighbour = self.checkNeighbour(i,j)
                livingNeighboursCount = []

                for neighbourCell in checkNeighbour
                    if neighbourCell.isAlive
                        livingNeighboursCount.push(neighbourCell)
                    end
                end
                #Si la celula actual esta viva, checa el estado de los vecinos
                
                if statusMainCell 
                    if ( livingNeighboursCount.length < 2 ) or (livingNeighboursCount.length > 3 ) 
                        deadCells.push(cellObject)
                    elsif ( livingNeighboursCount.length == 3 ) or (livingNeighboursCount.length == 2 ) 
                        aliveCells.push(cellObject)
                    end
                else
                    if livingNeighboursCount.length == 3
                        aliveCells.push(cellObject)
                    end
                end
            end
        end

        for cellItems in aliveCells
            cellItems.setAlive
        end
        for cellItems in deadCells
            cellItems.setDead
        end

    end

    def checkNeighbour(checkRow , checkColumn)
        #Metodo para checar todos los vecinos de todas las celulas
        #Definimos el rango de busqueda 
        searchMin = -1
        searchMax = 1

        #creamos una lista vacia de los vecinos encontrados
        neighbourList = []

        for i in searchMin..searchMax do
            for j in searchMin..searchMax do
                neighbourRow = checkRow + i
                neighbourColumn = checkColumn + j                
                validNeighbour = true

                if (neighbourRow == checkRow) and (neighbourColumn == checkColumn)
                    validNeighbour = false
                elsif (neighbourRow < 0 ) or (neighbourRow >= @rows)
                    validNeighbour = false
                elsif (neighbourColumn < 0) or (neighbourColumn >= @columns)
                    validNeighbour = false
                end 

                if validNeighbour
                    neighbourList.push(@grid[neighbourRow][neighbourColumn])
                end
            end
        end
        neighbourList
    end

    def getBoardSize
        1.times do
            print "Filas:\n"
            @rows = gets.to_i
            redo if @rows <= 1
        end
        1.times do
            print "Columnas:\n"
            @columns = gets.to_i
            redo if @columns <= 1
        end
    end

end

board1 = Board.new
board1.drawBoard

i = 1
counter = 1
print "\nPresione 1 para continuar:"
i = gets.to_i
while i == 1 do
    counter+=1
    
    board1.updateBoard
    puts "\nGeneracion #{counter}"
    board1.drawBoard
    
    print "\nPresione 1 para continuar:"
    i = gets.to_i
   
end