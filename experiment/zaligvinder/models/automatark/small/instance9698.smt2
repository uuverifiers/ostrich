(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /appendChild\u{28}\s*document\u{2e}createElement\u{28}\s*[\u{22}\u{27}]button[\u{22}\u{27}].*?outerText\s*=\s*[\u{22}\u{27}]{2}/smi
(assert (str.in_re X (re.++ (str.to_re "/appendChild(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "document.createElement(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "button") (re.union (str.to_re "\u{22}") (str.to_re "'")) (re.* re.allchar) (str.to_re "outerText") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "/smi\u{0a}"))))
; LoggerovplUser-Agent\x3At=searchreslt\x7D\x7BSysuptime\x3A
(assert (not (str.in_re X (str.to_re "LoggerovplUser-Agent:t=searchreslt}{Sysuptime:\u{0a}"))))
; ^-?((([0-9]{1,3},)?([0-9]{3},)*?[0-9]{3})|([0-9]{1,3}))\.[0-9]*$
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.opt (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ","))) (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re ".") (re.* (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[5,6]\d{7}|^$
(assert (not (str.in_re X (re.union (re.++ (re.union (str.to_re "5") (str.to_re ",") (str.to_re "6")) ((_ re.loop 7 7) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
