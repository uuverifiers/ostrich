(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; CD\x2F\.ico\x2FsLogearch195\.225\.
(assert (str.in_re X (str.to_re "CD/.ico/sLogearch195.225.\u{0a}")))
; [D]?[-D]?[0-9]{5}
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "D")) (re.opt (re.union (str.to_re "-") (str.to_re "D"))) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\.gif\u{3f}[a-f0-9]{4,7}\u{3d}\d{6,8}$/U
(assert (not (str.in_re X (re.++ (str.to_re "/.gif?") ((_ re.loop 4 7) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 6 8) (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
; \w?<\s?\/?[^\s>]+(\s+[^"'=]+(=("[^"]*")|('[^\']*')|([^\s"'>]*))?)*\s*\/?>
(assert (str.in_re X (re.++ (re.opt (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "<") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "/")) (re.+ (re.union (str.to_re ">") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re "="))) (re.opt (re.union (re.++ (str.to_re "=\u{22}") (re.* (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{22}")) (re.++ (str.to_re "'") (re.* (re.comp (str.to_re "'"))) (str.to_re "'")) (re.* (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ">") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "/")) (str.to_re ">\u{0a}"))))
; HXLogOnlyDaemonactivityIterenetFrom\x3AClass
(assert (not (str.in_re X (str.to_re "HXLogOnlyDaemonactivityIterenetFrom:Class\u{0a}"))))
(check-sat)
