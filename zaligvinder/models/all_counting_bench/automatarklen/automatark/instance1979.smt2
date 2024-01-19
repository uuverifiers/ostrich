(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /User-Agent\u{3a}\u{20}[^\u{0d}\u{0a}]*?\u{3b}U\u{3a}[^\u{0d}\u{0a}]{1,68}\u{3b}rv\u{3a}/H
(assert (not (str.in_re X (re.++ (str.to_re "/User-Agent: ") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re ";U:") ((_ re.loop 1 68) (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re ";rv:/H\u{0a}")))))
; Host\x3AuploadServer3AdapupdEFErrorSubject\u{3a}
(assert (not (str.in_re X (str.to_re "Host:uploadServer3AdapupdEFErrorSubject:\u{0a}"))))
; ^(((Ctrl\+Alt\+Shift\+Cmd\+|Ctrl\+Shift\+Cmd\+|Ctrl\+Alt\+Shift\+|Ctrl\+Alt\+Cmd\+|Alt\+Shift\+Cmd\+|Shift\+Cmd\+|Ctrl\+Shift\+|Ctrl\+Cmd\+|Ctrl\+Alt\+|Alt\+Shift\+|Alt\+Cmd\+|Cmd\+|Alt\+)(F1[0-2]|F[1-9]|[A-Za-z0-9\-\=\[\]\\\;\'\,\.\/]))|(Shift\+)?(F1[0-2]|F[1-9]))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "Ctrl+Alt+Shift+Cmd+") (str.to_re "Ctrl+Shift+Cmd+") (str.to_re "Ctrl+Alt+Shift+") (str.to_re "Ctrl+Alt+Cmd+") (str.to_re "Alt+Shift+Cmd+") (str.to_re "Shift+Cmd+") (str.to_re "Ctrl+Shift+") (str.to_re "Ctrl+Cmd+") (str.to_re "Ctrl+Alt+") (str.to_re "Alt+Shift+") (str.to_re "Alt+Cmd+") (str.to_re "Cmd+") (str.to_re "Alt+")) (re.union (re.++ (str.to_re "F1") (re.range "0" "2")) (re.++ (str.to_re "F") (re.range "1" "9")) (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "=") (str.to_re "[") (str.to_re "]") (str.to_re "\u{5c}") (str.to_re ";") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re "/"))) (re.++ (re.opt (str.to_re "Shift+")) (str.to_re "F") (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.range "1" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
