(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[1-9][0-9][0-9][0-9][0-9][0-9]$
(assert (str.in_re X (re.++ (re.range "1" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (str.to_re "\u{0a}"))))
; ^[D-d][K-k]-[1-9]{1}[0-9]{3}$
(assert (str.in_re X (re.++ (re.range "D" "d") (re.range "K" "k") (str.to_re "-") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\u{2f}[a-z]+\?[a-z]+=\d{6,7}$/U
(assert (str.in_re X (re.++ (str.to_re "//") (re.+ (re.range "a" "z")) (str.to_re "?") (re.+ (re.range "a" "z")) (str.to_re "=") ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
; /filename=[^\n]*\u{2e}j2k/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".j2k/i\u{0a}"))))
; ^(3276[0-7]|327[0-5]\d|32[0-6]\d{2}|3[01]\d{3}|[12]\d{4}|[1-9]\d{3}|[1-9]\d{2}|[1-9]\d|\d)$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "3276") (re.range "0" "7")) (re.++ (str.to_re "327") (re.range "0" "5") (re.range "0" "9")) (re.++ (str.to_re "32") (re.range "0" "6") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.union (str.to_re "1") (str.to_re "2")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
