(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\.php\?id=(\d{5}-\d{3}-\d{7}-\d{5}|0[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}1)&ver=\d{7}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/.php?id=") (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 5 5) (re.range "0" "9"))) (re.++ (str.to_re "0") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "-") ((_ re.loop 3 3) (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "-"))) ((_ re.loop 12 12) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "1"))) (str.to_re "&ver=") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
; /PRIVMSG #new :\u{02}\u{5b}(GOOGLE|SCAN)\u{5d}\u{02}\u{20}Scanning/
(assert (str.in_re X (re.++ (str.to_re "/PRIVMSG #new :\u{02}[") (re.union (str.to_re "GOOGLE") (str.to_re "SCAN")) (str.to_re "]\u{02} Scanning/\u{0a}"))))
; /filename=[^\n]*\u{2e}ogx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ogx/i\u{0a}")))))
; (^.+\|+[A-Za-z])
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ re.allchar) (re.+ (str.to_re "|")) (re.union (re.range "A" "Z") (re.range "a" "z")))))
; ^([\(]{1}[0-9]{3}[\)]{1}[ |\-]{0,1}|^[0-9]{3}[\-| ])?[0-9]{3}(\-| ){1}[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt (re.union (re.++ ((_ re.loop 1 1) (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "|") (str.to_re "-")))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re "|") (str.to_re " "))))) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
