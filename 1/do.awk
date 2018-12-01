{
    sum += $1
    table[NR] = $1
}

END {
    # part 1
    print sum

    # part 2
    while (1) {
        for (i in table) {
            sum2 += table[i]
            freq[sum2] += 1
        }
        if (freq[sum2] >= 2) {
            print sum2
            exit
        }
    }
}
