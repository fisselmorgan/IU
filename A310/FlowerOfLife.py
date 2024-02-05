import turtle

def main():
    filename = input("Please enter filename of drawing: ")
    t = turtle.Turtle()
    screen = t.getscreen()
    file = open(filename, 'r')
    for line in file:
        text = line.strip()
        commandList = text.split(",")
        command = commandList[0]
        if command == "goto":
            x = float(commandList[1])
            y = float(commandList[2])
            #width = float(commandList[3])
            #color = commandList[4].strip()
            #t.width(width)
            #t.pencolor(color)
            t.goto(x,y)
        elif command == "right":
            x = float(commandList[1])
            t.right(x)
        elif command == "left":
            x = float(commandList[1])
            t.left(x)
        elif command == "fd":
            x = float(commandList[1])
            t.fd(x)
        elif command == "back":
            x = float(commandList[1])
            t.back(x)
        elif command == "circle":
            radius = float(commandList[1])
            degreeRot = float(commandList[2])
            #color = float(commandList[3])
            #t.width(width)
            #t.pencolor(color)
            t.circle(radius, degreeRot)
        elif command == "beginfill":
            color = commandList[1].strip()
            t.fillcolor(color)
            t.begin_fill()
        elif command == "endfill":
            t.end_fill()
        elif command == "pu":
            t.pu()
        elif command == "pd":
            t.pd()
        else:
            print("Unknown command found in file: ", command)
    #close
    file.close()

    #hide turtle
    t.ht()

    screen.exitonclick()
    print("Execution Complete")
            

if __name__ == "__main__":
    main()
    
