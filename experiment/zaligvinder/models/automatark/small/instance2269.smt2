(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^User-Agent\u{3a}\u{20}[A-Z]{9}\u{0d}\u{0a}/Hm
(assert (str.in_re X (re.++ (str.to_re "/User-Agent: ") ((_ re.loop 9 9) (re.range "A" "Z")) (str.to_re "\u{0d}\u{0a}/Hm\u{0a}"))))
; Subject\u{3a}\s+Yeah\!Online\u{25}21\u{25}21\u{25}21
(assert (str.in_re X (re.++ (str.to_re "Subject:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Yeah!Online%21%21%21\u{0a}"))))
; User-Agent\x3A\s+ocllceclbhs\u{2f}gth.*Host\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ocllceclbhs/gth") (re.* re.allchar) (str.to_re "Host:\u{0a}")))))
; /filename=[^\n]*\u{2e}fli/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".fli/i\u{0a}"))))
(check-sat)
