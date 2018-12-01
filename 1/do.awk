{
    sum += $1
    table[sum] += 1
    if (table[sum] >= 2)
        print sum
}

END {
    print sum
}
