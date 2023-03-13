(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(((Ctrl\+Shift\+Alt\+|Ctrl\+Shift\+|Ctrl\+Alt\+|Shift\+Alt\+|Ctrl\+|Alt\+){1}(F1[0-2]|F[1-9]|[A-Za-z0-9\-\=\[\]\\\;\'\,\.\/]){1}){1}|(Shift\+)?(F1[0-2]|F[1-9]){1})$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (re.++ ((_ re.loop 1 1) (re.union (str.to_re "Ctrl+Shift+Alt+") (str.to_re "Ctrl+Shift+") (str.to_re "Ctrl+Alt+") (str.to_re "Shift+Alt+") (str.to_re "Ctrl+") (str.to_re "Alt+"))) ((_ re.loop 1 1) (re.union (re.++ (str.to_re "F1") (re.range "0" "2")) (re.++ (str.to_re "F") (re.range "1" "9")) (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "=") (str.to_re "[") (str.to_re "]") (str.to_re "\u{5c}") (str.to_re ";") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re "/"))))) (re.++ (re.opt (str.to_re "Shift+")) ((_ re.loop 1 1) (re.++ (str.to_re "F") (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.range "1" "9")))))) (str.to_re "\u{0a}"))))
; http[s]?://(www|[a-zA-Z]{2}-[a-zA-Z]{2})\.facebook\.com/(pages/[a-zA-Z0-9\.-]+/[0-9]+|[a-zA-Z0-9\.-]+)[/]?$
(assert (not (str.in_re X (re.++ (str.to_re "http") (re.opt (str.to_re "s")) (str.to_re "://") (re.union (str.to_re "www") (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "-") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re ".facebook.com/") (re.union (re.++ (str.to_re "pages/") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "-"))) (str.to_re "/") (re.+ (re.range "0" "9"))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "-")))) (re.opt (str.to_re "/")) (str.to_re "\u{0a}")))))
; DesktopBladeclient=wwwHello\x2Exmlns\x3A
(assert (str.in_re X (str.to_re "DesktopBladeclient=wwwHello.xmlns:\u{0a}")))
; IP\s+\.hta.*Theef2trustyfiles\x2Ecomlogs
(assert (not (str.in_re X (re.++ (str.to_re "IP") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".hta") (re.* re.allchar) (str.to_re "Theef2trustyfiles.comlogs\u{0a}")))))
(check-sat)
