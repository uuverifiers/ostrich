(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((0{1})?([0-3]{0,1}))(\.[0-9]{0,2})?$|^(4)(\.[0]{1,2})?$|^((0{1})?([0-4]{0,1}))(\.)?$
(assert (str.in_re X (re.union (re.++ (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")))) (re.opt ((_ re.loop 1 1) (str.to_re "0"))) (re.opt (re.range "0" "3"))) (re.++ (str.to_re "4") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (str.to_re "0"))))) (re.++ (re.opt (str.to_re ".")) (str.to_re "\u{0a}") (re.opt ((_ re.loop 1 1) (str.to_re "0"))) (re.opt (re.range "0" "4"))))))
; gpstool\u{2e}globaladserver\u{2e}com\daction\x2ESearchdata2\.activshopper\.com
(assert (not (str.in_re X (re.++ (str.to_re "gpstool.globaladserver.com") (re.range "0" "9") (str.to_re "action.Searchdata2.activshopper.com\u{0a}")))))
; User-Agent\u{3a}User-Agent\x3A
(assert (not (str.in_re X (str.to_re "User-Agent:User-Agent:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
