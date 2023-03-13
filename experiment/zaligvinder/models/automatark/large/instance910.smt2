(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /Content-Disposition\u{3a}\u{20}inline\u{3b}[^\u{0d}\u{0a}]filename=[a-z]{5,8}\d{2,3}\.pdf\u{0d}\u{0a}/Hm
(assert (str.in_re X (re.++ (str.to_re "/Content-Disposition: inline;") (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}")) (str.to_re "filename=") ((_ re.loop 5 8) (re.range "a" "z")) ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ".pdf\u{0d}\u{0a}/Hm\u{0a}"))))
; ^[ .a-zA-Z0-9:-]{1,150}$
(assert (str.in_re X (re.++ ((_ re.loop 1 150) (re.union (str.to_re " ") (str.to_re ".") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ":") (str.to_re "-"))) (str.to_re "\u{0a}"))))
; ^([0-9]|[1-9][0-9]|[1-9][0-9][0-9])$
(assert (str.in_re X (re.++ (re.union (re.range "0" "9") (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "9") (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; Host\x3APortawww\.thecommunicator\.net
(assert (not (str.in_re X (str.to_re "Host:Portawww.thecommunicator.net\u{0a}"))))
(check-sat)
