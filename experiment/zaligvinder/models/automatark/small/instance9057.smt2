(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\u{3a}\s+Host\x3A\s+proxystylesheet=Excitefhfksjzsfu\u{2f}ahm\.uqs
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "proxystylesheet=Excitefhfksjzsfu/ahm.uqs\u{0a}"))))
; \d+([\.|\,][0]+?[1-9]+)?
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re ".") (str.to_re "|") (str.to_re ",")) (re.+ (str.to_re "0")) (re.+ (re.range "1" "9")))) (str.to_re "\u{0a}")))))
; ^((.){1,}(\d){1,}(.){0,})$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ re.allchar) (re.+ (re.range "0" "9")) (re.* re.allchar)))))
; [A-Za-z]{1,2}[\d]{1,2}[A-Za-z]{0,1}\s*[\d]
(assert (not (str.in_re X (re.++ ((_ re.loop 1 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.range "0" "9") (str.to_re "\u{0a}")))))
(check-sat)
