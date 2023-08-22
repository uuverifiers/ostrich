(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(((Ctrl\+Alt\+Shift\+Cmd\+|Ctrl\+Shift\+Cmd\+|Ctrl\+Alt\+Shift\+|Ctrl\+Alt\+Cmd\+|Alt\+Shift\+Cmd\+|Shift\+Cmd\+|Ctrl\+Shift\+|Ctrl\+Cmd\+|Ctrl\+Alt\+|Alt\+Shift\+|Alt\+Cmd\+|Cmd\+|Alt\+)(F1[0-2]|F[1-9]|[A-Za-z0-9\-\=\[\]\\\;\'\,\.\/]))|(Shift\+)?(F1[0-2]|F[1-9]))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "Ctrl+Alt+Shift+Cmd+") (str.to_re "Ctrl+Shift+Cmd+") (str.to_re "Ctrl+Alt+Shift+") (str.to_re "Ctrl+Alt+Cmd+") (str.to_re "Alt+Shift+Cmd+") (str.to_re "Shift+Cmd+") (str.to_re "Ctrl+Shift+") (str.to_re "Ctrl+Cmd+") (str.to_re "Ctrl+Alt+") (str.to_re "Alt+Shift+") (str.to_re "Alt+Cmd+") (str.to_re "Cmd+") (str.to_re "Alt+")) (re.union (re.++ (str.to_re "F1") (re.range "0" "2")) (re.++ (str.to_re "F") (re.range "1" "9")) (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "=") (str.to_re "[") (str.to_re "]") (str.to_re "\u{5c}") (str.to_re ";") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re "/"))) (re.++ (re.opt (str.to_re "Shift+")) (str.to_re "F") (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.range "1" "9")))) (str.to_re "\u{0a}"))))
; (IE-?)?[0-9][0-9A-Z\+\*][0-9]{5}[A-Z]
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "IE") (re.opt (str.to_re "-")))) (re.range "0" "9") (re.union (re.range "0" "9") (re.range "A" "Z") (str.to_re "+") (str.to_re "*")) ((_ re.loop 5 5) (re.range "0" "9")) (re.range "A" "Z") (str.to_re "\u{0a}")))))
; Google\s+-~-GREATHost\u{3a}FILESIZE\x3E
(assert (not (str.in_re X (re.++ (str.to_re "Google") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "-~-GREATHost:FILESIZE>\u{13}\u{0a}")))))
; /filename=[^\n]*\u{2e}afm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".afm/i\u{0a}")))))
; ^([0-1]?[0-9]|[2][0-3]):([0-5][0-9]):([0-5][0-9])$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re "::\u{0a}") (re.range "0" "5") (re.range "0" "9") (re.range "0" "5") (re.range "0" "9"))))
(assert (> (str.len X) 10))
(check-sat)
