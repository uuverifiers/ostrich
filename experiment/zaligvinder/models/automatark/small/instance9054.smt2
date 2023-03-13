(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3AX-Mailer\u{3a}toolbar\.wishbone\.com
(assert (str.in_re X (str.to_re "Host:X-Mailer:\u{13}toolbar.wishbone.com\u{0a}")))
; (".+"\s)?<?[a-z\._0-9]+[^\._]@([a-z0-9]+\.)+[a-z0-9]{2,6}>?;?
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "\u{22}") (re.+ re.allchar) (str.to_re "\u{22}") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.opt (str.to_re "<")) (re.+ (re.union (re.range "a" "z") (str.to_re ".") (str.to_re "_") (re.range "0" "9"))) (re.union (str.to_re ".") (str.to_re "_")) (str.to_re "@") (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "."))) ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "0" "9"))) (re.opt (str.to_re ">")) (re.opt (str.to_re ";")) (str.to_re "\u{0a}"))))
; /\u{2e}opus([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.opus") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^\s*(((\d*\.?\d*[0-9]+\d*)|([0-9]+\d*\.\d*) )\s*[xX]\s*){2}((\d*\.?\d*[0-9]+\d*)|([0-9]+\d*\.\d*))\s*$
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.++ (re.union (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (re.+ (re.range "0" "9")) (re.* (re.range "0" "9"))) (re.++ (str.to_re " ") (re.+ (re.range "0" "9")) (re.* (re.range "0" "9")) (str.to_re ".") (re.* (re.range "0" "9")))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "x") (str.to_re "X")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (re.union (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (re.+ (re.range "0" "9")) (re.* (re.range "0" "9"))) (re.++ (re.+ (re.range "0" "9")) (re.* (re.range "0" "9")) (str.to_re ".") (re.* (re.range "0" "9")))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
(check-sat)
