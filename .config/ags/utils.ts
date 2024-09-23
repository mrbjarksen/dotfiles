export const twoDigit = (num: number) => num.toString().padStart(2, '0')

export const withSuffix = (num: number) => {
    const hundreds = num % 100
    if (hundreds >= 10 && hundreds < 20) return `${num}th`
    switch (hundreds % 10) {
        case 1:  return `${num}st`
        case 2:  return `${num}nd`
        case 3:  return `${num}rd`
        default: return `${num}th`
    }
}

export const withUnits = (value: number, precision: number, base: number, units: string[]) => {
    let i = 0
    while (value > base && i < units.length - 1) value /= base, i++;
    return `${value.toFixed(precision)} ${units[i]}`
}
