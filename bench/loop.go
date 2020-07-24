package main

import "fmt"
        
func main() {
    a := 0
    i := 0
    for i <= 100000000 {
        a = a + i
        i = i + 1
    }
    fmt.Printf("%d\n", a)        
}