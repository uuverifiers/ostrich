(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\{(.+)|^\\(.+)|(\}*)
(assert (str.in_re X (re.union (re.++ (str.to_re "{") (re.+ re.allchar)) (re.++ (str.to_re "\u{5c}") (re.+ re.allchar)) (re.++ (re.* (str.to_re "}")) (str.to_re "\u{0a}")))))
; www\x2Eweepee\x2Ecom\s+www\x2Ewebfringe\x2Ecomwww\.123mania\.com\x2F0409
(assert (str.in_re X (re.++ (str.to_re "www.weepee.com\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.webfringe.comwww.123mania.com/0409\u{0a}"))))
; Host\x3A\sHello\x2E.*forum=
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Hello.") (re.* re.allchar) (str.to_re "forum=\u{0a}")))))
; ^[-\w\s"'=/!@#%&,;:`~\.\$\^\{\[\(\|\)\]\}\*\+\?\\]*$
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re "-") (str.to_re "\u{22}") (str.to_re "'") (str.to_re "=") (str.to_re "/") (str.to_re "!") (str.to_re "@") (str.to_re "#") (str.to_re "%") (str.to_re "&") (str.to_re ",") (str.to_re ";") (str.to_re ":") (str.to_re "`") (str.to_re "~") (str.to_re ".") (str.to_re "$") (str.to_re "^") (str.to_re "{") (str.to_re "[") (str.to_re "(") (str.to_re "|") (str.to_re ")") (str.to_re "]") (str.to_re "}") (str.to_re "*") (str.to_re "+") (str.to_re "?") (str.to_re "\u{5c}") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; ^((\d){3})(-)?(\d){2}(-)?(\d){4}(A|B[1-7]?|M|T|C[1-4]|D)$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re "A") (re.++ (str.to_re "B") (re.opt (re.range "1" "7"))) (str.to_re "M") (str.to_re "T") (re.++ (str.to_re "C") (re.range "1" "4")) (str.to_re "D")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
