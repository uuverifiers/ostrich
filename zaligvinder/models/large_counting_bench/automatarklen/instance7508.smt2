(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /click.php\?c=\w{160}/Ui
(assert (str.in_re X (re.++ (str.to_re "/click") re.allchar (str.to_re "php?c=") ((_ re.loop 160 160) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/Ui\u{0a}"))))
; X-OSSproxy\u{3a}\w+\+Version\+\s+fast-look\x2Ecomwww\x2Emaxifiles\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "X-OSSproxy:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "+Version+") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "fast-look.comwww.maxifiles.com\u{0a}")))))
(assert (< 200 (str.len X)))
(check-sat)
