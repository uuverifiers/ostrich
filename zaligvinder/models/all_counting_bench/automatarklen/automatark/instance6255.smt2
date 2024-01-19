(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^-?\d{1,3}\.(\d{3}\.)*\d{3},\d\d$|^-?\d{1,3},\d\d$
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "."))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ",") (re.range "0" "9") (re.range "0" "9")) (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") (re.range "0" "9") (re.range "0" "9") (str.to_re "\u{0a}")))))
; Host\x3A\d+rprpgbnrppb\u{2f}ci[^\n\r]*RXFilteredDmInf\x5E
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "rprpgbnrppb/ci") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "RXFilteredDmInf^\u{0a}")))))
; ^(((Ctrl\+Alt\+Shift\+Cmd\+|Ctrl\+Shift\+Cmd\+|Ctrl\+Alt\+Shift\+|Ctrl\+Alt\+Cmd\+|Alt\+Shift\+Cmd\+|Shift\+Cmd\+|Ctrl\+Shift\+|Ctrl\+Cmd\+|Ctrl\+Alt\+|Alt\+Shift\+|Alt\+Cmd\+|Cmd\+|Alt\+)(F1[0-2]|F[1-9]|[A-Za-z0-9\-\=\[\]\\\;\'\,\.\/]))|(Shift\+)?(F1[0-2]|F[1-9]))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "Ctrl+Alt+Shift+Cmd+") (str.to_re "Ctrl+Shift+Cmd+") (str.to_re "Ctrl+Alt+Shift+") (str.to_re "Ctrl+Alt+Cmd+") (str.to_re "Alt+Shift+Cmd+") (str.to_re "Shift+Cmd+") (str.to_re "Ctrl+Shift+") (str.to_re "Ctrl+Cmd+") (str.to_re "Ctrl+Alt+") (str.to_re "Alt+Shift+") (str.to_re "Alt+Cmd+") (str.to_re "Cmd+") (str.to_re "Alt+")) (re.union (re.++ (str.to_re "F1") (re.range "0" "2")) (re.++ (str.to_re "F") (re.range "1" "9")) (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "=") (str.to_re "[") (str.to_re "]") (str.to_re "\u{5c}") (str.to_re ";") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re "/"))) (re.++ (re.opt (str.to_re "Shift+")) (str.to_re "F") (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.range "1" "9")))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}pfm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pfm/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
