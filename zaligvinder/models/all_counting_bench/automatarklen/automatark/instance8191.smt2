(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /appendChild\u{28}\s*document\u{2e}createElement\u{28}\s*[\u{22}\u{27}]button[\u{22}\u{27}].*?outerText\s*=\s*[\u{22}\u{27}]{2}/smi
(assert (str.in_re X (re.++ (str.to_re "/appendChild(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "document.createElement(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "button") (re.union (str.to_re "\u{22}") (str.to_re "'")) (re.* re.allchar) (str.to_re "outerText") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "/smi\u{0a}"))))
; X-Spam-Level:\s[*]{11}
(assert (str.in_re X (re.++ (str.to_re "X-Spam-Level:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 11 11) (str.to_re "*")) (str.to_re "\u{0a}"))))
; (^13((\ )?\d){4}$)|(^1[38]00((\ )?\d){6}$)|(^(((\(0[23478]\))|(0[23478]))(\ )?)?\d((\ )?\d){7}$)
(assert (str.in_re X (re.union (re.++ (str.to_re "13") ((_ re.loop 4 4) (re.++ (re.opt (str.to_re " ")) (re.range "0" "9")))) (re.++ (str.to_re "1") (re.union (str.to_re "3") (str.to_re "8")) (str.to_re "00") ((_ re.loop 6 6) (re.++ (re.opt (str.to_re " ")) (re.range "0" "9")))) (re.++ (str.to_re "\u{0a}") (re.opt (re.++ (re.union (re.++ (str.to_re "(0") (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "7") (str.to_re "8")) (str.to_re ")")) (re.++ (str.to_re "0") (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "7") (str.to_re "8")))) (re.opt (str.to_re " ")))) (re.range "0" "9") ((_ re.loop 7 7) (re.++ (re.opt (str.to_re " ")) (re.range "0" "9")))))))
; /\u{2e}asx([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.asx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
