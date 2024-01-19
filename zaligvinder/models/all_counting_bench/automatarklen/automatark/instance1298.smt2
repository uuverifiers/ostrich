(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /(\d*\.?\d+)\s?(px|em|ex|%|in|cn|mm|pt|pc+)/igm
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "px") (str.to_re "em") (str.to_re "ex") (str.to_re "%") (str.to_re "in") (str.to_re "cn") (str.to_re "mm") (str.to_re "pt") (re.++ (str.to_re "p") (re.+ (str.to_re "c")))) (str.to_re "/igm\u{0a}") (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.+ (re.range "0" "9"))))))
; /\.getElements?By(Id|TagName)\u{28}\s*[\u{22}\u{27}]caption[\u{22}\u{27}]\s*\u{29}.*?innerHTML\s*\u{3d}\s*[\u{22}\u{27}]\u{3c}thead/sm
(assert (not (str.in_re X (re.++ (str.to_re "/.getElement") (re.opt (str.to_re "s")) (str.to_re "By") (re.union (str.to_re "Id") (str.to_re "TagName")) (str.to_re "(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "caption") (re.union (str.to_re "\u{22}") (str.to_re "'")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ")") (re.* re.allchar) (str.to_re "innerHTML") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "<thead/sm\u{0a}")))))
; ^http\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?$
(assert (not (str.in_re X (re.++ (str.to_re "http://") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.++ (str.to_re "/") (re.* (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))) (str.to_re "\u{0a}")))))
; User-Agent\x3A.*Host\u{3a}\s+www\x2Ewordiq\x2Ecom\s+Subject\x3AAlexaOnline\u{25}21\u{25}21\u{25}21
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.wordiq.com\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Subject:AlexaOnline%21%21%21\u{0a}")))))
; /\u{2e}jp2([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.jp2") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
