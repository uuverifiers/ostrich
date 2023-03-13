(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ".*?"|".*$|'.*?'|'.*$
(assert (str.in_re X (re.union (re.++ (str.to_re "\u{22}") (re.* re.allchar) (str.to_re "\u{22}")) (re.++ (str.to_re "\u{22}") (re.* re.allchar)) (re.++ (str.to_re "'") (re.* re.allchar) (str.to_re "'")) (re.++ (str.to_re "'") (re.* re.allchar) (str.to_re "\u{0a}")))))
; Host\x3A\s+Host\x3A\u{7c}roogoo\u{7c}Testiufilfwulmfi\u{2f}riuf\.lio
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:|roogoo|Testiufilfwulmfi/riuf.lio\u{0a}"))))
; ^([0-9]*|\d*\.\d{1}?\d*)$
(assert (str.in_re X (re.++ (re.union (re.* (re.range "0" "9")) (re.++ (re.* (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9")) (re.* (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; version\s+error\*\-\*WrongUser-Agent\x3Acom\x2Findex\.php\?tpid=
(assert (not (str.in_re X (re.++ (str.to_re "version") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "error*-*WrongUser-Agent:com/index.php?tpid=\u{0a}")))))
; ^[1-9]{1}[0-9]{3}\s{0,1}?[a-zA-Z]{2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
(check-sat)
