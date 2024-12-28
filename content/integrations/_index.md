---
title: Integrations
weight: 120
---

# Integrations

<div class="row">
    <div class="col-lg-3 bg-light cd-sidebar navbar-expand-lg">
        {{ partial "sidebar.html" . }}
    </div>
    <div class="col-lg-7 cd-content">
        <div id="content" class="DocSearch-content">
            <h1>Library</h1>
            <h2 id="supported-integrations">Supported Integrations<a class="heading-link" href="#supported-integrations"></a></h2>
            <p>Integrations connect third-party services to Selector. Below you'll find a complete list of the supported integrations within our library. Click on each integration for more details and configuration instructions.</p>
            <p>Premium integrations, which are denoted by lightening bolt icon ( <i class="fas fa-bolt accent-color"></i> ), generate their own service dashboards upon installaion.</p>
            <div class="card-deck">
                {{ range where .RegularPages ".Params.legacy" "!=" true  }}
                    <div class="card d-block integration-card">
                        <a class="card-link" href="{{.Permalink}}"></a>
                        <div class="card-top">
                            {{ with .Params.logo_light }}<img src="{{ . }}">{{ end }}
                        </div>
                        <div class="card-body">
                            {{ with .Params.premium }}<i class="fas fa-bolt accent-color"></i>{{ end }} <span class="card-title">{{ .Title }}</span>
                        </div>
                    </div>
                {{ end }}
            </div>
            {{ .Content }}
            {{ partial "footer.html" . }}
        </div>
    </div>
    <div class="d-none d-lg-flex col-lg-2 cd-sidenav">
        {{ partial "sidenav.html" . }}
    </div>
</div>
