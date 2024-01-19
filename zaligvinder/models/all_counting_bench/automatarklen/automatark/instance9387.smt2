(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^([\w]+[^\W])([^\W]\.?)([\w]+[^\W]$))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))))))
; [a-z]{1}[a-z0-9\-_\.]{2,24}@tlen\.pl
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "a" "z")) ((_ re.loop 2 24) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "_") (str.to_re "."))) (str.to_re "@tlen.pl\u{0a}")))))
; Download\d+ocllceclbhs\u{2f}gth
(assert (str.in_re X (re.++ (str.to_re "Download") (re.+ (re.range "0" "9")) (str.to_re "ocllceclbhs/gth\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
