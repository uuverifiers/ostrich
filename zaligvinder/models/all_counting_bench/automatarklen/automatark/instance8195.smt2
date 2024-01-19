(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1-9]\d{0,3}|[1-5]\d{4}|6[0-4]\d{3}|65[0-4]\d{2}|655[0-2]\d|6553[0-5])$
(assert (str.in_re X (re.++ (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9"))) (re.++ (re.range "1" "5") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "6") (re.range "0" "4") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "65") (re.range "0" "4") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "655") (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "6553") (re.range "0" "5"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}f4b/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".f4b/i\u{0a}"))))
; /filename=[^\n]*\u{2e}m4v/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".m4v/i\u{0a}")))))
; Host\x3A.*rt[^\n\r]*Host\x3AUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "rt") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:User-Agent:\u{0a}"))))
; ^[A-Za-z]{3,4}[0-9]{6}$
(assert (str.in_re X (re.++ ((_ re.loop 3 4) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
