package main

import "fmt"
        
func main() {
    a := 0
    i := 0
    s := 1
    for i <= 100000000 {
        a = a + s * i
        i = i + 1
        s = -s
    }
    fmt.Printf("%d\n", a)        
}