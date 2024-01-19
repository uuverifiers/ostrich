(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}wk4/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wk4/i\u{0a}"))))
; <link href="../Common/Styles/iLienStyle.css" type="text/css" rel="stylesheet" />
(assert (not (str.in_re X (re.++ (str.to_re "<link href=\u{22}") re.allchar re.allchar (str.to_re "/Common/Styles/iLienStyle") re.allchar (str.to_re "css\u{22} type=\u{22}text/css\u{22} rel=\u{22}stylesheet\u{22} />\u{0a}")))))
; /filename=[a-z]{5,8}\d{2,3}\.jar\u{0d}\u{0a}/Hm
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 5 8) (re.range "a" "z")) ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ".jar\u{0d}\u{0a}/Hm\u{0a}")))))
; ^((0{1})?([0-3]{0,1}))(\.[0-9]{0,2})?$|^(4)(\.[0]{1,2})?$|^((0{1})?([0-4]{0,1}))(\.)?$
(assert (str.in_re X (re.union (re.++ (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")))) (re.opt ((_ re.loop 1 1) (str.to_re "0"))) (re.opt (re.range "0" "3"))) (re.++ (str.to_re "4") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (str.to_re "0"))))) (re.++ (re.opt (str.to_re ".")) (str.to_re "\u{0a}") (re.opt ((_ re.loop 1 1) (str.to_re "0"))) (re.opt (re.range "0" "4"))))))
; /filename=[^\n]*\u{2e}cgm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".cgm/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
