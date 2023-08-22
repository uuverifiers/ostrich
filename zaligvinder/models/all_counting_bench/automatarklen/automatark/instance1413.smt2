(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \<\!doctype\s+(([^\s\>]+)\s+)?(([^\s\>]+)\s*)?(\"([^\/]+)\/\/([^\/]+)\/\/([^\s]+)\s([^\/]+)\/\/([^\"]+)\")?(\s*\"([^\"]+)\")?\>
(assert (str.in_re X (re.++ (str.to_re "<!doctype") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.++ (re.+ (re.union (str.to_re ">") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (re.opt (re.++ (re.+ (re.union (str.to_re ">") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (re.opt (re.++ (str.to_re "\u{22}") (re.+ (re.comp (str.to_re "/"))) (str.to_re "//") (re.+ (re.comp (str.to_re "/"))) (str.to_re "//") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.+ (re.comp (str.to_re "/"))) (str.to_re "//") (re.+ (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{22}"))) (re.opt (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}") (re.+ (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{22}"))) (str.to_re ">\u{0a}"))))
; ^(\+65)?\d{8}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "+65")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\u{2e}m4p([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.m4p") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
