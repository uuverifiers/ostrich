(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \\[\\w{2}\\]
(assert (not (str.in_re X (re.++ (str.to_re "\u{5c}") (re.union (str.to_re "\u{5c}") (str.to_re "w") (str.to_re "{") (str.to_re "2") (str.to_re "}")) (str.to_re "\u{0a}")))))
; /\?spl=\d&br=[^&]+&vers=[^&]+&s=/H
(assert (str.in_re X (re.++ (str.to_re "/?spl=") (re.range "0" "9") (str.to_re "&br=") (re.+ (re.comp (str.to_re "&"))) (str.to_re "&vers=") (re.+ (re.comp (str.to_re "&"))) (str.to_re "&s=/H\u{0a}"))))
; ^\[0-9]{4}\-\[0-9]{2}\-\[0-9]{2}$
(assert (not (str.in_re X (re.++ (str.to_re "[0-9") ((_ re.loop 4 4) (str.to_re "]")) (str.to_re "-[0-9") ((_ re.loop 2 2) (str.to_re "]")) (str.to_re "-[0-9") ((_ re.loop 2 2) (str.to_re "]")) (str.to_re "\u{0a}")))))
; ^([1-9][0-9]?|100)%$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.range "1" "9") (re.opt (re.range "0" "9"))) (str.to_re "100")) (str.to_re "%\u{0a}")))))
; [0-9]{5}\s?[0-9]{5}
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
