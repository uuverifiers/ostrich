(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; EFError.*Host\x3A\swww\u{2e}malware-stopper\u{2e}com
(assert (str.in_re X (re.++ (str.to_re "EFError") (re.* re.allchar) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.malware-stopper.com\u{0a}"))))
; ^[A-Za-z]{1}[0-9]{7}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[A-Za-z]{6}[0-9]{2}[A-Za-z]{1}[0-9]{2}[A-Za-z]{1}[0-9]{3}[A-Za-z]{1}$
(assert (str.in_re X (re.++ ((_ re.loop 6 6) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}"))))
; ([A-Za-z0-9]+:\/\/)?([a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*)?(\/|(\/([A-Za-z0-9\:@!\$&'\(\}\*\+\-_,;=~\.]+|(%[A-F0-9]{2})+))*)(\?[A-Za-z0-9]+=[A-Za-z0-9]+(&[A-Za-z0-9]+=[A-Za-z0-9]+)*)?
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "://"))) (re.opt (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))))) (re.union (str.to_re "/") (re.* (re.++ (str.to_re "/") (re.union (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re ":") (str.to_re "@") (str.to_re "!") (str.to_re "$") (str.to_re "&") (str.to_re "'") (str.to_re "(") (str.to_re "}") (str.to_re "*") (str.to_re "+") (str.to_re "-") (str.to_re "_") (str.to_re ",") (str.to_re ";") (str.to_re "=") (str.to_re "~") (str.to_re "."))) (re.+ (re.++ (str.to_re "%") ((_ re.loop 2 2) (re.union (re.range "A" "F") (re.range "0" "9"))))))))) (re.opt (re.++ (str.to_re "?") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "=") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.* (re.++ (str.to_re "&") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "=") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))))))) (str.to_re "\u{0a}")))))
; <(\/{0,1})img(.*?)(\/{0,1})\>
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.opt (str.to_re "/")) (str.to_re "img") (re.* re.allchar) (re.opt (str.to_re "/")) (str.to_re ">\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
