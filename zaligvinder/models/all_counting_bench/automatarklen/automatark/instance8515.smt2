(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\u{3a}\w+Owner\x3A
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Owner:\u{0a}"))))
; /filename=[^\n]*\u{2e}search-ms/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".search-ms/i\u{0a}")))))
; ^[a-zA-Z]\w{0,30}$
(assert (not (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 0 30) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
