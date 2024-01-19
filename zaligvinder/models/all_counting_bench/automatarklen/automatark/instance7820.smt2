(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(((Ctrl\+Alt\+Shift\+Cmd\+|Ctrl\+Shift\+Cmd\+|Ctrl\+Alt\+Shift\+|Ctrl\+Alt\+Cmd\+|Alt\+Shift\+Cmd\+|Shift\+Cmd\+|Ctrl\+Shift\+|Ctrl\+Cmd\+|Ctrl\+Alt\+|Alt\+Shift\+|Alt\+Cmd\+|Cmd\+|Alt\+)(F1[0-2]|F[1-9]|[A-Za-z0-9\-\=\[\]\\\;\'\,\.\/]))|(Shift\+)?(F1[0-2]|F[1-9]))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "Ctrl+Alt+Shift+Cmd+") (str.to_re "Ctrl+Shift+Cmd+") (str.to_re "Ctrl+Alt+Shift+") (str.to_re "Ctrl+Alt+Cmd+") (str.to_re "Alt+Shift+Cmd+") (str.to_re "Shift+Cmd+") (str.to_re "Ctrl+Shift+") (str.to_re "Ctrl+Cmd+") (str.to_re "Ctrl+Alt+") (str.to_re "Alt+Shift+") (str.to_re "Alt+Cmd+") (str.to_re "Cmd+") (str.to_re "Alt+")) (re.union (re.++ (str.to_re "F1") (re.range "0" "2")) (re.++ (str.to_re "F") (re.range "1" "9")) (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "=") (str.to_re "[") (str.to_re "]") (str.to_re "\u{5c}") (str.to_re ";") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re "/"))) (re.++ (re.opt (str.to_re "Shift+")) (str.to_re "F") (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.range "1" "9")))) (str.to_re "\u{0a}")))))
; HXDownload\s+Host\x3AArcadeHourspjpoptwql\u{2f}rlnjFrom\x3A
(assert (not (str.in_re X (re.++ (str.to_re "HXDownload") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:ArcadeHourspjpoptwql/rlnjFrom:\u{0a}")))))
; http://www.mail-password-recovery.com/
(assert (str.in_re X (re.++ (str.to_re "http://www") re.allchar (str.to_re "mail-password-recovery") re.allchar (str.to_re "com/\u{0a}"))))
; ^[1-9]{1}[0-9]{3}\s?[a-zA-Z]{2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
