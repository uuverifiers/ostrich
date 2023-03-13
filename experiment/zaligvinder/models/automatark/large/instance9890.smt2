(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /click.php\?c=\w{160}/Ui
(assert (str.in_re X (re.++ (str.to_re "/click") re.allchar (str.to_re "php?c=") ((_ re.loop 160 160) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/Ui\u{0a}"))))
(check-sat)
