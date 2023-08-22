(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (<(!--|script)(.|\n[^<])*(--|script)>)|(<|<)(/?[\w!?]+)\s?[^<]*(>|>)|(\&[\w]+\;)
(assert (str.in_re X (re.union (re.++ (str.to_re "<") (re.union (str.to_re "!--") (str.to_re "script")) (re.* (re.union re.allchar (re.++ (str.to_re "\u{0a}") (re.comp (str.to_re "<"))))) (re.union (str.to_re "--") (str.to_re "script")) (str.to_re ">")) (re.++ (str.to_re "<") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.comp (str.to_re "<"))) (str.to_re ">") (re.opt (str.to_re "/")) (re.+ (re.union (str.to_re "!") (str.to_re "?") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.++ (str.to_re "\u{0a}&") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ";")))))
; Host\u{3a}\s+hostiedesksearch\.dropspam\.com\x2Fbi\x2Fservlet\x2FThinstall
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "hostiedesksearch.dropspam.com/bi/servlet/Thinstall\u{0a}"))))
; <title>+(.*?)</title>
(assert (not (str.in_re X (re.++ (str.to_re "<title") (re.+ (str.to_re ">")) (re.* re.allchar) (str.to_re "</title>\u{0a}")))))
; ^(1[89]|[2-9]\d)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.union (str.to_re "8") (str.to_re "9"))) (re.++ (re.range "2" "9") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; urn:[a-z0-9]{1}[a-z0-9\-]{1,31}:[a-z0-9_,:=@;!'%/#\(\)\+\-\.\$\*\?]+
(assert (not (str.in_re X (re.++ (str.to_re "urn:") ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "0" "9"))) ((_ re.loop 1 31) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (str.to_re ":") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re ",") (str.to_re ":") (str.to_re "=") (str.to_re "@") (str.to_re ";") (str.to_re "!") (str.to_re "'") (str.to_re "%") (str.to_re "/") (str.to_re "#") (str.to_re "(") (str.to_re ")") (str.to_re "+") (str.to_re "-") (str.to_re ".") (str.to_re "$") (str.to_re "*") (str.to_re "?"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
